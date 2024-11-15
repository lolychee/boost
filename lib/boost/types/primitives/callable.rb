# frozen_string_literal: true

module Boost
  module Types
    module Primitives
      module Callable
        include Type
        include Is[Respond[:call]]
        extend self

        def initialize_customize(...) end
      end
    end
  end
end
