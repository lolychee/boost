# frozen_string_literal: true

module Boost
  module Types
    module Type
      include Module::Customizable

      def ===(other) = @type === other

      def initialize_customize(type) = @type = type
    end
  end
end
