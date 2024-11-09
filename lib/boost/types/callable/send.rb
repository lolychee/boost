# frozen_string_literal: true

module Boost
  module Types
    module Callable
      module Send
        include Module::Customizable
        extend self

        def call(object)
          if @kwargs
            object.send(@method_name, *@args, **@kwargs, &@block)
          else
            object.send(@method_name, *@args, &@block)
          end
        rescue ArgumentError => e
          raise unless /wrong number of arguments \(given \d+, expected (?<expected>\d+)\)/ =~ e.message

          expected = expected.to_i
          args = @args.dup
          block = args.size > expected && args.last.is_a?(Proc) ? args.pop : @block
          kwargs = args.size > expected && args.last.is_a?(Hash) ? args.pop : @kwargs

          if kwargs
            object.send(@method_name, *args, **kwargs, &block)
          else
            object.send(@method_name, *args, &block)
          end
        end

        def initialize_customize(method_name, *args, **kwargs, &block)
          @method_name = method_name
          @args = args
          @kwargs = kwargs if kwargs.any?
          @block = block if block
        end
      end
    end
  end
end
