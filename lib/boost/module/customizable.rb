# frozen_string_literal: true

module Boost
  module Module
    module Customizable
      attr_reader :original

      def initialize_copy(source)
        super
        set_temporary_name("#{source.name}[**customize**]")

        @original ||= source
      end

      def initialize_customize(...) end

      def customize(...)
        clone.tap { |customized| customized.initialize_customize(...) }
      end
      alias [] customize

      module WithConfigurable
        def initialize_copy(source)
          super

          @config = @original.config.dup
        end

        def initialize_customize(*, **, &)
          configure(**)
          super
        end
      end

      def self.extended(base)
        base.extend(WithConfigurable) if base.is_a?(Configurable)
      end
    end
  end
end
