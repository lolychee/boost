# frozen_string_literal: true

require "forwardable"

module Boost
  module Method
    class DependencyInject < ::Module
      include Decorator

      class Dependencies
        extend Forwardable

        def_delegators :@deps, *%i[key? keys empty? any? size length]

        def initialize(deps = {})
          @deps = deps
        end

        def []=(name, dependency)
          @deps[name] = dependency
        end

        def resolve_dependencies(receiver, block)
          block.parameters.filter_map do |type, name|
            next unless key?(name)

            case type
            when :keyreq, :key then [name, resolve_dependency(receiver, name)]
            end
          end.to_h
        end

        def resolve_dependency(receiver, name)
          if (block = @deps[name]).is_a?(::Proc)
            kwdeps = resolve_dependencies(receiver, block)
            case block.arity
            when 0 then block.call(**kwdeps)
            else block.call(receiver, **kwdeps)
            end
          else
            block
          end
        end
      end

      def initialize(deps = {})
        super()

        deps = Dependencies.new(deps)

        define_method(:call) do |*args, **kwargs, &block|
          receiver = case self
                     when ::Method then self.receiver
                     when ::Proc   then binding.receiver
                     else raise ArgumentError, "block must be a Proc or Method"
                     end

          super(*args, **deps.resolve_dependencies(receiver, self), **kwargs, &block)
        end
        alias_method(:[], :call)

        define_method(:to_proc) { method(:call).to_proc }
      end
    end
  end
end
