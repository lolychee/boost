# frozen_string_literal: true

module Boost
  module Module
    module Customizable
      class Arguments
        def initialize(...)
          apply!(...)
        end

        def apply(...) = clone.tap { |new| new.apply!(...) }

        def apply!(*args, **kwargs, &block)
          defined?(@args)   ? args.each_with_index { |arg, i| @args[i] = arg }  : (@args = args)
          defined?(@kwargs) ? kwargs.each { |key, value| @kwargs[key] = value } : (@kwargs = kwargs)
          @block = block if block_given?
        end

        def any? = @args&.any? || @kwargs&.any? || !@block
        def empty? = !any?

        def inspect
          [
            @args.any?   ? @args.inspect[1..-2]   : nil,
            @kwargs.any? ? @kwargs.inspect[1..-2] : nil,
            @block       ? :& : nil
          ].compact.join(", ")
        end

        def [](key)
          case key
          when Integer, Range then @args[key]
          else @kwargs[key]
          end
        end
      end

      attr_reader :__original__, :customizations

      def initialize_copy(source)
        super

        @__original__ ||= source
        extend Includable unless is_a?(::Class)
      end

      def initialize_customize(...)
        @customizations = defined?(@customizations) ? @customizations.apply(...) : Arguments.new(...)

        raise ArgumentError, "At least one argument is required" if @customizations.empty?

        return unless __original__&.name

        set_temporary_name("#{__original__.name}[#{@customizations.inspect}]")
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
