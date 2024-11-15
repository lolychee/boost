# frozen_string_literal: true

module Boost
  module Types
    module Builtin
      module Enumerable
        module Customizable
          SIZE_TYPE = Primitives::Or[Primitives::InstanceOf[::Integer], Primitives::InstanceOf[::Range]]

          def initialize_customize(value_type = nil, size = nil, **constraints)
            types = [@type]
            if size.nil? && SIZE_TYPE === value_type
              size = value_type
              value_type = nil
            end

            types << Primitives::Return[size, :size] unless size.nil?
            types << Primitives::Return[true, Primitives::Send[:all?] { |v| value_type === v }] unless value_type.nil?
            types += constraints.map { |k, v| build_constraint(k, v) } if constraints.any?

            super(Primitives::And[*types])
          end

          def build_constraint(key, value)
            case key
            when Integer then Primitives::Return[value, Primitives::Send[:[], key]]
            when Range   then Primitives::Return[
              true, Primitives::Send[:[], key] >> Primitives::Send[:all?] { |v| value === v }
            ]
            else raise ArgumentError, "Unknown constraint: #{key}"
            end
          end
        end

        module Abstract
          include Primitives::Is
          extend self

          def included(base) = super || base.include(Customizable)
        end

        include Abstract[::Enumerable]
        extend self

        # module Index
        #   include Is[Or[::Integer, ::Range]]
        #   extend self
        # end
      end
    end
  end
end
