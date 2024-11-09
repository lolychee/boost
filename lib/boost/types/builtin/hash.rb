# frozen_string_literal: true

module Boost
  module Types
    module Builtin
      module Hash
        include Type
        extend self

        initialize_customize(Operators::Is[::Hash])

        def initialize_customize(value_type = nil, size = nil, **constraints)
          type = @type
          if size.nil? && (value_type.is_a?(::Integer) || value_type.is_a?(::Range))
            size = value_type
            value_type = nil
          end
          unless value_type.nil?
            type = Operators::And[type, Callable::Return[true] { |h| h.all? { |_, value| value_type === value } }]
          end
          type = Operators::And[type, Callable::Return[size, Callable::Send[:size]]] unless size.nil?
          type = Operators::And[type, *constraints.map { |k, v| build_constraint(k, v) }] if constraints.any?

          super(type)
        end

        private

        ZERO_PARAMS_METHODS = %i[
          length
          size
          count
          empty?
          any?
        ].freeze

        BOOLEAN_METHODS = %i[
          include?
          intersect?
          eql?
          all?
          none?
          one?
          member?
          key?
        ].freeze

        def build_constraint(key, value)
          case key
          when *ZERO_PARAMS_METHODS then Callable::Return[value, key]
          when *BOOLEAN_METHODS     then Callable::Return[true, Callable::Send[key, *Array(value)]]
          else raise ArgumentError, "Unknown constraint: #{name}"
          end
        end
      end
    end
  end
end
