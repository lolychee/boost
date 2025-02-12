module Boost
  module Decorator
    class Chain < ::Module
      include Decorator

      def initialize(registry = {})
        @registry = registry
        @stack = Stack.new
      end

      def decorate(obj, ...)
        super do
          @stack.decorate(obj, ...)
        end
      end

      def <<(decorator)
        @stack << decorator
        self
      end

      def clear!
        @stack.clear!
        self
      end

      def respond_to_missing?(name, include_private = false)
        @registry.key?(name) || super
      end

      def method_missing(name, ...)
        if @registry.key?(name)
          self << @registry[name].new(...)
        else
          super
        end
      end
    end
  end
end
