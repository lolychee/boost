# frozen_string_literal: true

require "forwardable"

module Boost
  module Decorators
    class Stack < ::Module
      extend Forwardable

      def_delegators :included_modules, :empty?, :any?, :size, :each, :to_a

      def extended(_)
        freeze
      end
      alias included extended
      alias prepended extended
    end
  end
end
