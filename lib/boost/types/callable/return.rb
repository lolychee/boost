# frozen_string_literal: true

module Boost
  module Types
    module Callable
      module Return
        include Required
        extend self

        def ===(other) = super(@send.call(other))

        def initialize_customize(type, send = nil, &block)
          super(type)
          @send = block || Send[send]
        end
      end
    end
  end
end
