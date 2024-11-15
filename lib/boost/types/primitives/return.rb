# frozen_string_literal: true

module Boost
  module Types
    module Primitives
      module Return
        include Primitive
        extend self
        extend DoNotUseDirectly

        def ===(other) = super(@send.call(other)).tap { |result| @on_match&.call(result) }

        def initialize_customize(type, *args, **kwargs, &on_match)
          super(type)
          @send = Send[*args, **kwargs]
          @on_match = on_match
        end
      end
    end
  end
end
