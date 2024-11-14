# frozen_string_literal: true

module Boost
  module Types
    module Callable
      module Optional
        include Parameter
        include Primitives::Nilable[Primitives::Any]
        extend self
      end
    end
  end
end
