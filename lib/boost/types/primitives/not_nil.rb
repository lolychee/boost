# frozen_string_literal: true

module Boost
  module Types
    module Primitives
      module NotNil
        include Not[nil]
        extend self
        extend CanNotCustomize
      end
    end
  end
end
