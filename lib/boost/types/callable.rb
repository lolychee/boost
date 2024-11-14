# frozen_string_literal: true

module Boost
  module Types
    module Callable
      include Type
      include Primitives::Is[Respond[:call]]
      extend self

      def initialize_customize(...) end
    end
  end
end
