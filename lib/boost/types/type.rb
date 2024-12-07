# frozen_string_literal: true

module Boost
  module Types
    module Type
      include Logical

      module ClassMethods
        def [](...)
          new(...)
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end

      def initialize(type)
        @type = type
      end

      def ===(other)
        @type === other
      end

      def ==(other)
        self.class == other.class && @type == other.instance_variable_get(:@type)
      end

      def self.cast(type)
        case type
        when self
          type
        when ::Module
          Primitives::Send[:kind_of?, type].returns(true)
        else
          Logical::Is.new(type)
        end
      end
    end
  end
end
