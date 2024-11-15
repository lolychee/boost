# frozen_string_literal: true

module Boost
  module Types
    module Primitives
      module KindOf
        include Primitive
        extend self
        extend DoNotUseDirectly

        def ===(other) = other.kind_of?(@type) # rubocop:disable Style/ClassCheck
      end
    end
  end
end
