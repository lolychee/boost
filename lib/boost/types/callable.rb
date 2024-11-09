# frozen_string_literal: true

module Boost
  module Types
    module Callable
      include Type
      extend self

      initialize_customize(Respond[:call])

      def initialize_customize() end
    end
  end
end
