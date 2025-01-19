# frozen_string_literal: true

module Boost
  class Method < ::Module
    include Decorator

    def initialize(decorator = Decorators::Chain.new)
      super()

      include Toggleable

      define_method(:bind) { |receiver| decorator.decorate(super(receiver), wrapper: nil) }
      define_method(:bind_call) { |receiver, *args, **kwargs, &block| bind(receiver).call(*args, **kwargs, &block) }
    end
  end
end
