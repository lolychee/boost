# frozen_string_literal: true

module Boost
  module Types
    module Primitives
      class Respond
        include Type

        attr_reader :method_name, :parameters

        def initialize(method_name, *args, **kwargs)
          @method_name = method_name
          @parameters = Parameters.new(*args, **kwargs) if args.any? || kwargs.any?
        end

        def ===(other)
          other.respond_to?(@method_name) && (!defined?(@parameters) || @parameters === other.method(@method_name))
        end

        def ==(other)
          instance_of?(other.class) && @method_name == other.method_name && @parameters == other.parameters
        end
      end
    end
  end
end
