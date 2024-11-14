# frozen_string_literal: true

module Boost
  module Types
    module Primitives
      module Not
        include Primitive
        extend self
        extend DoNotUseDirectly

        def ===(other) = super || !(@type === other)
      end
    end
  end
end
