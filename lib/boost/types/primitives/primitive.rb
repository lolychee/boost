# frozen_string_literal: true

module Boost
  module Types
    module Primitives
      module Primitive
        include Type

        def ===(other) = @type === other || self == other

        def initialize_customize(type) = @type = type.is_a?(Operators::Operator) ? type : Operators::Is[type]
      end
    end
  end
end
