# frozen_string_literal: true

require "forwardable"

module Boost
  module Types
    module Primitives
      class Send
        extend Forwardable
        include Type

        def initialize(method_name, *args, **kwargs, &block)
          if method_name.respond_to?(:to_proc) && args.empty? && kwargs.empty? && block.nil?
            @proc = method_name.to_proc
          else
            @method_name = method_name
            @args = args
            @kwargs = kwargs
            @block = block
          end
        end

        def returns(type)
          dup.tap { |new| new.instance_variable_set(:@returns, type) }
        end

        FUNC = lambda do |method_name, args, kwargs, block, object|
          object.send(method_name, *args, **kwargs, &block)
          # rescue ArgumentError => e
          #   raise unless /wrong number of arguments \(given \d+, expected (?<expected>\d+)\)/ =~ e.message
          #   raise unless (args.size - expected.to_i).positive?

          #   rest = args[expected...]
          #   args = args[...expected]

          #   block   = rest.pop if rest.last.is_a?(Proc)
          #   kwargs  = rest.pop if rest.last.is_a?(Hash)

          #   object.send(method_name, *args, **kwargs, &block)
        end

        def to_proc
          @proc || FUNC.curry[@method_name, @args, @kwargs, @block]
        end
        def_delegators :to_proc, :call, :yield

        def ===(other)
          result = call(other)
          defined?(@returns) ? @returns === result : result
        end

        def ==(other)
          instance_of?(other.class) &&
            @method_name == other.instance_variable_get(:@method_name) &&
            @args == other.instance_variable_get(:@args) &&
            @kwargs == other.instance_variable_get(:@kwargs) &&
            @block == other.instance_variable_get(:@block)
        end

        def >>(other)
          dup.tap { |new| new.instance_variable_set(:@proc, to_proc >> other) }
        end

        def <<(other)
          dup.tap { |new| new.instance_variable_set(:@proc, to_proc << other) }
        end

        def curry(...)
          dup.tap { |new| new.instance_variable_set(:@proc, to_proc.curry(...)) }
        end
      end
    end
  end
end
