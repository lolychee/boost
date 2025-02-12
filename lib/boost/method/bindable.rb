# frozen_string_literal: true

module Boost
  module Method
    module Bindable
      attr_writer :fn

      def fn
        @fn ||= Decorator::Chain.new(DECORATOR_REGISTRY)
      end

      def bind(receiver)
        fn.decorate(super(receiver), wrapper: nil)
      end

      def bind_call(receiver, *args, **kwargs, &block)
        bind(receiver).call(*args, **kwargs, &block)
      end
    end
  end
end
