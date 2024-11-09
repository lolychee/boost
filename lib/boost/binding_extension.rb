# frozen_string_literal: true

module Boost
  module BindingExtension
    def boost(*, **, &)
      Boost.new(self, *, **).self_or_call(&)
    end

    class Boost
      module Callable
        def self_or_call(&) = block_given? ? call(&) : self
        def call(&) = yield
      end
      include Callable

      module DependenciesInjectable
        def initialize(binding)
          @binding = binding
          deps[:current_module], = binding.eval("Module.nesting")
        end

        def deps = @deps ||= Dependencies.new
        def call(&block) = super { deps.call(block) }
      end
      include DependenciesInjectable
    end
  end
end
