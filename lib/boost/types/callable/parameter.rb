# frozen_string_literal: true

module Boost
  module Types
    module Callable
      module Parameter
        include Type

        def ===(other) = @type === other || self == other
        def initialize_customize(type) = @type = type
      end
    end
  end
end
