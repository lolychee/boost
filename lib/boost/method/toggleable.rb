# frozen_string_literal: true

module Boost
  class Method
    module Toggleable
      def enable!
        @disabled = false
        setup!
        self
      end

      def enabled? = !@disabled

      def disable!
        @disabled = true
        setup!
        self
      end

      def disabled? = @disabled

      def setup!(...)
        enabled? ? super : (owner.method_defined?(name) && owner.remove_method(name))
      end
    end
  end
end
