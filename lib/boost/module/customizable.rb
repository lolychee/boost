# frozen_string_literal: true

module Boost
  module Module
    module Customizable
      attr_reader :original

      def initialize_copy(source)
        super
        @original = source.original || source
        extend Includable unless is_a?(::Class)
      end

      def initialize_customize(...) end

      def set_customized_name(*args, **kwargs, &block)
        return unless original&.name

        signature = [
          args.any?   ? args.inspect[1..-2]   : nil,
          kwargs.any? ? kwargs.inspect[1..-2] : nil,
          block       ? :& : nil
        ].compact.join(", ")
        set_temporary_name("#{original.name}[#{signature}]")
      end

      module Includable
        EXCEPT_VARIABLES = %i[@original].freeze
        def included(base)
          super(base)
          (instance_variables - EXCEPT_VARIABLES).each do |name|
            base.instance_variable_set(name, instance_variable_get(name))
          end
        end
      end

      def customize(*args, **kwargs, &block)
        clone.tap do |new|
          new.set_customized_name(*args, **kwargs, &block)
          new.initialize_customize(*args, **kwargs, &block)
        end
      end

      alias [] customize
    end
  end
end
