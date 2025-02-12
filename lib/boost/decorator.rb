# frozen_string_literal: true

require "delegate"

module Boost
  module Decorator
    class Wrapper < ::SimpleDelegator
      attr_accessor :__decorator__

      def initialize(obj = nil)
        # @__decorator__ = decorator
        super(obj)
      end

      def is_a?(klass)
        super || __getobj__.is_a?(klass)
      end

      def kind_of?(klass)
        super || __getobj__.is_a?(klass)
      end

      def instance_of?(klass)
        super || __getobj__.instance_of?(klass)
      end
    end

    def decorate(obj, wrapper: Wrapper)
      obj = wrapper.new(obj) unless !wrapper || obj.is_a?(wrapper)
      if block_given?
        yield(obj)
      else
        obj.extend self
      end
      obj
    end
  end
end
