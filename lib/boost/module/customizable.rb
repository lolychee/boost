# frozen_string_literal: true

module Boost
  module Module
    module Customizable
      attr_reader :original

      def initialize_copy(source)
        super
        @original ||= source

        set_temporary_name("#{source.name}[**customize**]")
      end

      def initialize_customize(...) = defined?(super) && super

      def customize(...) = clone.tap { |new| new.initialize_customize(...) }
      alias [] customize
    end
  end
end
