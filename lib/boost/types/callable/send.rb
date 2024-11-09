# frozen_string_literal: true

module Boost
  module Types
    module Callable
      module Send
        def self.[](method_name, *args, **kwargs, &block)
          return method_name if method_name.is_a?(::Proc) || method_name.is_a?(::Method)

          lambda do |object|
            object.send(method_name, *args, **kwargs, &block)
          rescue ArgumentError => e
            raise unless /wrong number of arguments \(given \d+, expected (?<expected>\d+)\)/ =~ e.message
            raise unless (args.size - expected.to_i).positive?

            rest = args[expected...]
            args = args[...expected]

            block   = rest.pop if rest.last.is_a?(Proc)
            kwargs  = rest.pop if rest.last.is_a?(Hash)

            object.send(@method_name, *args, **kwargs, &block)
          end
        end
      end
    end
  end
end
