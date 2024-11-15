# frozen_string_literal: true

module Boost
  module Types
    module Primitives
      module And
        include Primitive
        extend self
        extend DoNotUseDirectly

        def ===(other) = !defined?(@types) || @types.all? { |type| type === other }

        def ==(other)
          super || (
            !other.instance_variable_defined?(:@types) || (
              @types.size == other.instance_variable_get(:@types).size &&
              @types.zip(other.instance_variable_get(:@types)).all? { |a, b| a == b }
            )
          )
        end

        def initialize_customize(*types)
          raise ArgumentError, "At least two types are required" if types.size < 2

          @types ||= []
          types.each { |type| @types << Type.cast(type) }
        end
      end
    end
  end
end
