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
          mod, = @nesting
          if mod.nil?
            # boost.logger.warn "method defined in anonymous module or class, skipping"
            return super
          elsif !mod.singleton_class.include?(Toggleable) || mod.on?
            return super
          end

          @binding.eval <<~RUBY
            return super if defined?(super)
            e = NoMethodError.new("undefined method `\#{__callee__}' for \#{self.inspect}")
            e.set_backtrace(caller[3..-1])
            raise(e)
          RUBY
        end
      end

      BindingExtension::Boost.include BoostMethods
    end
  end
end
