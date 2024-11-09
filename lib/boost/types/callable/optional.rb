# frozen_string_literal: true

module Boost
  module Types
    module Callable
      module Optional
        include Parameter
        extend self

        initialize_customize(Primitives::Any)
        def initialize_customize(type) = super(Primitives::Nilable[type])
      end
    end
  end
end
