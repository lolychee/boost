# frozen_string_literal: true

module Boost
  module Types
    module Callable
      module Parameters
        include Type
        extend self

        def ===(other)
          return true unless defined?(@args) || defined?(@kwargs)

          parameters = other.is_a?(::Proc) ? other.parameters(lambda: true) : other.parameters
          args = []
          kwargs = {}
          parameters.each_with_index do |(type, name), i|
            case type
            when :req     then args[i]      = Required
            when :opt     then args[i]      = Optional
            when :rest    then kwargs[:*]   = Rest
            when :keyreq  then kwargs[name] = Required
            when :key     then kwargs[name] = Optional
            when :keyrest then kwargs[:**]  = Rest
            when :block   then kwargs[:&]   = Block
            end
          end

          return false if defined?(@args) && !@args.each_with_index.all? do |type, i|
            (i < args.size) && type === args[i]
          end
          return false if defined?(@kwargs) && !@kwargs.each_pair.all? do |name, type|
            kwargs.key?(name) && type === kwargs[name]
          end

          true
        end

        def initialize_customize(*args, **kwargs)
          @args   = args    if args.any?
          @kwargs = kwargs  if kwargs.any?
        end
      end
    end
  end
end
