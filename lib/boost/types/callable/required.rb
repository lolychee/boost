# frozen_string_literal: true

module Boost
  module Types
    module Callable
      module Required
        include Parameter
        extend self

        initialize_customize(Operators::Not[nil])

        def initialize_customize(type) = super(Operators::Is[type])
      end
    end
  end
end
