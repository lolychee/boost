# frozen_string_literal: true

module Boost
  class Method
    module Toggleable
      def enable!
        @disabled = false
        setup!(force: true)
        self
      end

      def enabled? = !@disabled

      def disable!
        @disabled = true
        setup!(force: true)
        self
      end

      def disabled? = @disabled

      def setup!(...)
        enabled? ? super : owner.remove_method(name)
      end
    end
  end
end
