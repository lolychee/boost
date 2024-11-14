# frozen_string_literal: true

module Boost
  module Types
    module Callable
      module Parameter
        include Type

        def ===(other) = @type === other || self == other
      end
    end
  end
end
