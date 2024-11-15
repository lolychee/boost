# frozen_string_literal: true

module Boost
  module Types
    module Primitives
      module Callable
        include Respond[:call]
        extend self
        extend Primitive::CanNotCustomize
      end
    end
  end
end
