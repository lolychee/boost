module Boost
  module Decorator
    class Block < ::Module
      include Decorator

      def initialize(&proc)
        define_method(:call) { |*args, **kwargs, &block| proc.call(-> { super(*args, **kwargs, &block) }) }
      end
    end
  end
end
