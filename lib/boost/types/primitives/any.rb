# frozen_string_literal: true

module Boost
  module Types
    module Primitives
      module Any
        include Primitive
        extend self
        extend CanNotCustomize

        def ===(other) = true
      end
    end
  end
end
