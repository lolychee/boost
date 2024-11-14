# frozen_string_literal: true

module Boost
  module Types
    module Callable
      module Required
        include Parameter
        include Primitives::Is[Primitives::Not[NilClass]]
        extend self

        def initialize_customize(type) = super(Primitives::Is[type])
      end
    end
  end
end
