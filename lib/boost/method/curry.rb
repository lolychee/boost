# frozen_string_literal: true

module Boost
  module Method
    class Curry < ::Module
      include Decorator

      def initialize(*curried_args, **curried_kwargs)
        super()

        define_method(:call) do |*args, **kwargs, &block|
          super(*curried_args, *args, **curried_kwargs, **kwargs, &block)
        end
        alias_method(:[], :call)

        define_method(:to_proc) { method(:call).to_proc }
      end
    end
  end
end
