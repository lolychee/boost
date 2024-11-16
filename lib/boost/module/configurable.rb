# frozen_string_literal: true

module Boost
  module Module
    module Configurable
      class Configurations < Hash
        def respond_to_missing?(name, include_private = false)
          key?((name.end_with?("=") ? name[...-1] : name).to_sym) || super
        end

        def method_missing(name, *args, &)
          if name.end_with?("=")
            key = name[...-1].to_sym
            self.[]=(key, *args).tap { define_singleton_method(name) { |v| self[key] = v } }
          else
            key = name.to_sym
            self[key].tap { define_singleton_method(name) { self[key] } }
          end
        end
      end

      def config = @config ||= Configurations.new
      def configure(**) = config.merge!(**)

      def initialize_copy(source)
        super
        @config = defined?(@__original__) ? @__original__.config.dup : Configurations.new { |_h, k| source.config[k] }
      end

      def initialize_customize(*, **, &)
        super
        configure(**)
      end

      module Inheritable
        def inherited(subclass)
          super
          subclass.instance_variable_set(:@config, Configurations.new { |_h, k| config[k] })
        end
      end

      def self.extended(base)
        base.extend Inheritable if base.is_a?(::Class)
      end
    end
  end
end
