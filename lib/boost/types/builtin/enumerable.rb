module Boost
  module Types
    module Builtin
      module Enumerable
        module Customizable
          # def ==(other)
          #   super && (
          #     (!defined?(@value_type) || @value_type == other.instance_variable_get(:@value_type)) &&
          #     (!defined?(@size) || @size == other.instance_variable_get(:@size)) &&
          #     (!defined?(@constraints) || @constraints == other.instance_variable_get(:@constraints))
          #   )
          # end

          def initialize_customize(value_type = nil, size = nil, **constraints)
            type = @type
            if size.nil? && (value_type.instance_of?(::Integer) || value_type.instance_of?(::Range))
              size = value_type
              value_type = nil
            end
            type = Primitives::And[type, Callable::Return[size, :size]] unless size.nil?
            unless value_type.nil?
              type = Primitives::And[type, Callable::Return[true] { |a| a.all? { |v| value_type === v } }]
            end
            type = Primitives::And[type, *constraints.map { |k, v| build_constraint(k, v) }] if constraints.any?
            super(type)
          end

          def build_constraint(key, value)
            case key
            when Integer then Callable::Return[true] { |enumerable| value === enumerable[key] }
            when Range   then Callable::Return[true] do |enumerable|
              enumerable[key].all? do |item|
                value === item
              end
            end
            else raise ArgumentError, "Unknown constraint: #{key}"
            end
          end
        end

        module Is
          include Primitives::Is
          extend self

          def included(base) = super || base.include(Customizable)
        end

        include Is[::Enumerable]
        extend self

        module Index
          include Primitives::Is[Primitives::Or[::Integer, ::Range]]
          extend self
        end
      end
    end
  end
end
