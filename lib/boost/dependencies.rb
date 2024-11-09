# frozen_string_literal: true

require "forwardable"

module Boost
  module Dependencies
    class Registry
      extend Forwardable
      extend Enumerable

      def_delegators :@deps, *%i[
        key? keys empty? any? size length
      ]

      def initialize(deps = {})
        @deps = {}
        @cached = Hash.new { |_, k| resolve_dependency(k) }

        deps.each { |name, dep| self[name] = dep }
      end

      def each(&block)
        @cached.each(&block)
      end

      def [](name)
        @cached[name]
      end

      def []=(name, dep)
        (@deps[name] = dep).tap { @cached.delete(name) }
      end

      def call(block, *args, **kwargs, &)
        case block
        when ::Method
          scope = :method
          receiver = block.receiver
        when ::Proc
          scope = :block
          receiver = block.binding.receiver
        else
          raise ArgumentError, "block must be a Proc or Method"
        end

        @receiver = receiver

        resolve_dependencies(block, scope:) do |deps, kwdeps|
          deps.each_with_index { |dep, i| args[i] = dep unless dep.nil? }
          block.call(*args, **kwargs, **kwdeps, &)
        end
      ensure
        @receiver = nil
      end

      private

      def resolve_dependencies(block, scope: nil, &)
        args = []
        kwargs = {}
        block.parameters.each_with_index do |(type, name), i|
          next unless key?(name)

          case type
          when :req, :opt     then args[i]      = self[name] unless scope == :dependency
          when :keyreq, :key  then kwargs[name] = self[name]
          end
        end

        block_given? ? yield(args, kwargs) : [args, kwargs]
      end

      def resolve_dependency(name)
        return @cached[name] = @deps[name] unless (block = @deps[name]).is_a?(::Proc)

        resolve_dependencies(block, scope: :dependency) do |_, kwdeps|
          if block.arity.zero?
            @cached[name] = block.call(**kwdeps)
          else
            block.call(@receiver, **kwdeps)
          end
        end
      end
    end

    def deps
      @deps ||= Registry.new
    end
  end
end
