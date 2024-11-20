# frozen_string_literal: true

require "forwardable"

module Boost
  class Dependencies
    extend Forwardable
    extend Enumerable

    def_delegators :@deps, *%i[key? keys empty? any? size length]

    def initialize(deps = {})
      @deps = deps
      @cached = {}
    end

    def each(...) = @cached.each(...)

    def [](name) = @cached[name]

    def []=(name, dependency)
      @deps[name] = dependency.tap { @cached.delete(name) }
    end

    def call(block, *, **, &)
      case block
      when ::Method then receiver = block.receiver
      when ::Proc   then receiver = block.binding.receiver
      else raise ArgumentError, "block must be a Proc or Method"
      end

      block.call(*, **, **resolve_dependencies(receiver, block), &)
    end

    private

    def resolve_dependencies(receiver, block)
      block.parameters.filter_map do |type, name|
        next unless key?(name)

        case type
        when :keyreq, :key then [name, resolve_dependency(receiver, name)]
        end
      end.to_h
    end

    def resolve_dependency(receiver, name)
      @cached[name] ||=
        if (block = @deps[name]).is_a?(::Proc)
          kwdeps = resolve_dependencies(receiver, block)
          case block.arity
          when 0 then block.call(**kwdeps)
          else return block.call(receiver, **kwdeps)
          end
        else
          block
        end
    end
  end
end
