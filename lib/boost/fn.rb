# frozen_string_literal: true

module Boost
  module Fn
    def self.extended(base)
      base.extend Method::Marcos
    end

    def fn(*args, &block)
      name, = args
      method =
        if name
          @boost_methods[name] ||= Method.new(self, *args)
        else
          @defining_boost_method = Method.new(self, *args)
        end

      method.setup!(&block) if block_given?
      method
    end

    def method_added(name)
      super
      return unless @defining_boost_method

      (@boost_methods[name] ||= @defining_boost_method).tap do |method|
        @defining_boost_method = nil
        method.name = name
        method.original_method = instance_method(name)
        method.setup!
      end
    end
  end
end
