# frozen_string_literal: true

require "forwardable"

module Boost
  class DependencyInjector
    extend Forwardable
    extend Enumerable

    def_delegators :@deps, *%i[
      key? keys values each empty? size length values_at fetch fetch_values []=
    ]

    def initialize(binding, deps = {})
      @binding = binding
      @deps = deps
    end

    def [](name)
      @deps[name].tap do |dep|
        if dep.is_a?(::Proc)
          return dep.call(*(dep.arity.zero? ? [] : [@binding.receiver]))
        end
      end
    end

    def block_call(*args, **kwargs, &block)
      block.parameters.each_with_index do |(type, name), i|
        next unless key?(name)

        case type
        when :req, :opt     then args[i]      = self[name]
        when :keyreq, :key  then kwargs[name] = self[name]
        end
      end
      yield(*args, **kwargs)
    end

    def method_call(method_name, *args, **kwargs)
      @binding.receiver.method(method_name).parameters.each_with_index do |(type, name), i|
        next unless key?(name)

        case type
        when :req, :opt     then args[i]      = self[name]
        when :keyreq, :key  then kwargs[name] = self[name]
        end
      end
      @binding.receiver.send(method_name, *args, **kwargs)
    end
  end
end
