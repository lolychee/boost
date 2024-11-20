# frozen_string_literal: true

module Boost
  class Method
    module Curryable
      def curried(*args, **kwargs, &block)
        @curried_args = args
        @curried_kwargs = kwargs
        setup!(&block) if block_given?
        self
      end

      def bind_call(receiver, *args, **kwargs, &block)
        @curried_args ||= []
        @curried_kwargs ||= {}
        super(receiver, *@curried_args, *args, **@curried_kwargs, **kwargs, &block)
      end
    end
  end
end
