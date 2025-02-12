# frozen_string_literal: true

module Boost
  module Method
    module Toggleable
      def enabled?
        !@disabled
      end

      def enable!
        @disabled = false
        refine!
      end

      def disabled?
        @disabled
      end

      def disable!
        @disabled = true
        refine!
      end

      def refine!
        if disabled?
          owner.method_defined?(name) && owner.remove_method(name)
        else
          this = self
          owner.define_method(name) { |*args, **kwargs, &block| this.bind_call(self, *args, **kwargs, &block) }
        end
      end
    end
  end
end
