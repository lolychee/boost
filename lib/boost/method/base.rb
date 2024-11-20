# frozen_string_literal: true

require "forwardable"

module Boost
  class Method
    module Base
      extend Forwardable

      def_delegators :@original_method, :arity, :parameters, :source_location, :bind_call

      def initialize(owner, name = nil)
        @owner = owner
        @name = name
      end

      attr_writer :owner, :name

      def owner = @original_method&.owner || @owner
      def name  = @original_method&.name  || @name

      def original_method=(method)
        @original_method ||= method
      end

      def inspect
        @original_method.inspect.sub(@original_method.class.name, self.class.name)
      end

      def to_proc
        this = self
        proc do |*args, **kwargs, &block|
          this.bind_call(self, *args, **kwargs, &block)
        end
      end

      def setup!(force: !@skip_setup, &block)
        return unless force

        if block_given?
          raise ArgumentError, "name should be set" unless name

          owner.define_method(name, &block)
          self.original_method = owner.instance_method(name)
        end
        owner.define_method(name, &to_proc)
      ensure
        @skip_setup = true
      end
    end
  end
end
