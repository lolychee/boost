# frozen_string_literal: true

module Boost
  module Types
    module Primitives
      module Or
        include Primitive
        extend self
        extend DoNotUseDirectly

        def ===(other) = !defined?(@types) || @types.any? { |type| type === other }

        def initialize_customize(*types)
          raise ArgumentError, "At least two types are required" if types.size < 2

          (@types ||= []).push(*types.map { |type| Type.cast(type) })
        end
      end
    end
  end
end
