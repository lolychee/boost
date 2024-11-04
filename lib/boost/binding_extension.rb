# frozen_string_literal: true

module Boost
  module BindingExtension
    def boost(*, **, &)
      Boost.new(self, *, **).self_or_call(&)
    end

    class Boost
      def initialize(binding)
        @binding = binding
        @nesting = binding.eval("Module.nesting")
      end

      module Callable
        def self_or_call(&) = block_given? ? call(&) : self

        def call(&block)
          args = []
          kwargs = {}
          block.parameters.each do |type, name|
            dep = resolve_dependency(name)
            case type
            when :req, :opt     then args <<        dep if dep != NO_DEPENDENCY
            when :keyreq, :key  then kwargs[name] = dep if dep != NO_DEPENDENCY
            end
          end

          yield(*args, **kwargs)
        end

        protected

        NO_DEPENDENCY = Object.new
        def resolve_dependency(...) = NO_DEPENDENCY
      end
      include Callable
    end
  end
end
