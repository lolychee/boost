# frozen_string_literal: true

module Boost
  module Fn
    def self.extended(base)
      base.instance_variable_set(:@boost_methods, {})
    end

    REGISTRY = {
      curry: Method::Curry
    }.freeze

    def fn
      @boost_method_decorator = Decorators::Chain.new(REGISTRY)
    end

    def method_added(name)
      super
      return unless @boost_method_decorator

      (@boost_methods[name] ||= Method.new(@boost_method_decorator).decorate(instance_method(name))).tap do |method|
        @boost_method_decorator = nil
        method.refine!
      end
    end
  end
end
