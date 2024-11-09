# frozen_string_literal: true

module Boost
  module Types
    module Callable
      module Return
        include Module::Customizable
        extend self

        def ===(other) = @return_type === @send.call(other)

        def initialize_customize(return_type, send = nil, &block)
          @return_type = Operators::Is[return_type]
          @send = block || Send[send]
        end
      end
    end
  end
end
