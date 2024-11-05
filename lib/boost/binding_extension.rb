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
        def call(&) = yield
      end
      include Callable

      module DependencyInjectable
        def dependency_injector = @dependency_injector ||= DependencyInjector.new(@binding)
        alias deps dependency_injector
        def call(&) = super { dependency_injector.block_call(&) }
      end
      include DependencyInjectable
    end
  end
end
