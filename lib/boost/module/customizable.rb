# frozen_string_literal: true

module Boost
  module Module
    module Customizable
      attr_reader :__original__

      def initialize_copy(source)
        super

        @__original__ ||= source
        extend Includable unless is_a?(::Class)
      end

      def initialize_customize(*args, **kwargs, &block)
        raise ArgumentError, "At least one argument is required" if args.empty? && kwargs.empty? && block.nil?

        return unless __original__&.name

        arguments = [
          args.any?   ? args.inspect[1..-2]   : nil,
          kwargs.any? ? kwargs.inspect[1..-2] : nil,
          block       ? :& : nil
        ].compact.join(", ")

        set_temporary_name("#{__original__.name}[#{arguments}]")
      end

      module Includable
        def included(base)
          super(base)
          instance_variables.each do |name|
            next if name.start_with?("@__") && name.end_with?("__")

            base.instance_variable_set(name, instance_variable_get(name))
          end
        end
      end

      def customize(...) = clone.tap { |new| new.initialize_customize(...) }
      alias [] customize
    end
  end
end
