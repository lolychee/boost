# frozen_string_literal: true

module Boost
  module Decorators
    class Curry < ::Module
      def initialize(*curried_args, **curried_kwargs)
        super()
        define_method(:call) do |*args, **kwargs, &block|
          super(*curried_args, *args, **curried_kwargs, **kwargs, &block)
        end
      end
    end
  end
end
