# frozen_string_literal: true

module Boost
  module Types
    module Primitives
      module Not
        include Primitive
        extend self
        extend DoNotUseDirectly

        def ===(other) = !(@type === other)
      end
    end
  end
end
