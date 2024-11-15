# frozen_string_literal: true

require "forwardable"

module Boost
  module Types
    module Primitives
      module Send
        include Primitive
        extend Forwardable
        extend self
        extend DoNotUseDirectly

        FUNC = lambda do |method_name, args, kwargs, block, object|
          object.send(method_name, *args, **kwargs, &block)
        rescue ArgumentError => e
          raise unless /wrong number of arguments \(given \d+, expected (?<expected>\d+)\)/ =~ e.message
          raise unless (args.size - expected.to_i).positive?

          rest = args[expected...]
          args = args[...expected]

          block   = rest.pop if rest.last.is_a?(Proc)
          kwargs  = rest.pop if rest.last.is_a?(Hash)

          object.send(method_name, *args, **kwargs, &block)
        end

        def to_proc = @proc || FUNC.curry[@method_name, @args, @kwargs, @block]

        def_delegators :to_proc, :call, :yield, :curry, :>>, :<<

        def initialize_customize(method_name, *args, **kwargs, &block)
          if method_name.respond_to?(:to_proc) && args.empty? && kwargs.empty? && block.nil?
            @proc = method_name.to_proc
          else
            @method_name = method_name
            @args = args
            @kwargs = kwargs
            @block = block
          end
        end
      end
    end
  end
end
