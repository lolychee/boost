# frozen_string_literal: true

require "forwardable"

module Boost
  class Method
    module Base
      extend Forwardable

      def_delegators :@original_method, :owner, :name, :arity, :parameters, :source_location, :bind, :bind_call

      def initialize(original_method = nil)
        @original_method = original_method
      end

      attr_writer :original_method

      def inspect
        @original_method.nil? ? super : @original_method.inspect.sub(@original_method.class.name, self.class.name)
      end

      def to_proc
        this = self
        ->(*args, **kwargs, &block) { this.bind(self).call(*args, **kwargs, &block) }
      end

      def setup!
        owner.define_method(name, &to_proc)
      end
    end
  end
end
