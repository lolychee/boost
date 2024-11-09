# frozen_string_literal: true

module Boost
  module Types
    module Callable
      module Respond
        include Module::Customizable
        extend self

        def ===(other)
          other.respond_to?(@method_name) && (!defined?(@parameters) || @parameters === other.method(@method_name))
        end

        def initialize_customize(method_name, *args, **kwargs)
          @method_name = method_name
          @parameters = Parameters[*args, **kwargs] if args.any? || kwargs.any?
        end
      end
    end
  end
end
