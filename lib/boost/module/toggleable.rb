# frozen_string_literal: true

module Boost
  module Module
    module Toggleable
      def on! = @disabled = false
      def on? = !@disabled
      def off! = @disabled = true
      def off? = @disabled

      module BoostMethods
        def call(&)
          mod = deps[:current_module]
          if mod.nil?
            # boost.logger.warn "method defined in anonymous module or class, skipping"
            return super
          elsif !(mod.singleton_class < Toggleable) || mod.on?
            return super
          end

          @binding.eval <<~RUBY
            return super if defined?(super)
            raise NoMethodError, "undefined method `\#{__callee__}' for \#{self.inspect}", caller(6)
          RUBY
        end
      end

      BindingExtension::Boost.include BoostMethods
    end
  end
end
