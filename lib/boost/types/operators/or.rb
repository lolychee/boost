# frozen_string_literal: true

module Boost
  module Types
    module Operators
      module Or
        include Operator
        extend self

        def ===(other) = super || (!defined?(@types) || @types.any? { |type| type === other })

        def initialize_customize(*types)
          raise ArgumentError, "At least two types are required" if types.size < 2

          (@types ||= []).push(*types.map { |type| type.is_a?(Operator) ? type : Is[type] })
        end
      end
    end
  end
end
