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

    def each(&block)
      @cached.each(&block)
    end

    def [](name)
      @cached[name] || resolve_dependency(name)
    end

    def []=(name, dependency)
      @deps[name] = dependency.tap { @cached.delete(name) }
    end

    def call(block, *args, **, &)
      case block
      when ::Method
        scope = :method
        @receiver = block.receiver
      when ::Proc
        scope = :block
        @receiver = block.binding.receiver
      else
        raise ArgumentError, "block must be a Proc or Method"
      end

      deps, kwdeps = resolve_dependencies(block, scope:)

      block.call(*[args.size, deps.size].max.times.map { |i| deps[i] || args[i] }, **, **kwdeps, &)
    ensure
      @receiver = nil
    end

    private

    def resolve_dependencies(block, scope: nil)
      args = []
      kwargs = {}
      block.parameters.each_with_index do |(type, name), i|
        next unless key?(name)

        case type
        when :req, :opt     then args[i]      = resolve_dependency(name) unless scope == :dependency
        when :keyreq, :key  then kwargs[name] = resolve_dependency(name)
        end
      end

      [args, kwargs]
    end

    def resolve_dependency(name)
      @cached[name] ||=
        if (block = @deps[name]).is_a?(::Proc)
          _, kwdeps = resolve_dependencies(block, scope: :dependency)
          case block.arity
          when 0 then block.call(**kwdeps)
          else return block.call(@receiver, **kwdeps)
          end
        else
          block
        end
    end
  end
end
