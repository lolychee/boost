# frozen_string_literal: true

module Boost
  class Method
    module Decoratable
      def decorators
        @decorators ||= Decorators::Stack.new
      end

      def respond_to_missing?(name, include_private = false)
        Decorators.respond_to?(name) || super
      end

      def method_missing(name, ...)
        if Decorators.respond_to?(name)
          decorators.include Decorators.send(name, ...)
          self
        else
          super
        end
      end

      def bind(receiver)
        super.tap { |m| m.extend(decorators) }
      end
    end
  end
end
