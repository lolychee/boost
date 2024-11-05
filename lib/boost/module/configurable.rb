# frozen_string_literal: true

module Boost
  module Module
    module Configurable
      class Configurations < Hash
        def respond_to_missing?(name, include_private = false)
          key = name[-1] == "=" ? name[0..-2].to_sym : name.to_sym
          key?(key) || super
        end

        def method_missing(name, *args, &)
          if name[-1] == "="
            key = name[0..-2].to_sym
            value = self[key] = args.first
            # self.class.class_eval <<~RUBY, __FILE__, __LINE__ + 1
            #   def #{name}(value)
            #     self[#{key.inspect}] = value
            #   end
            # RUBY
          else
            key = name.to_sym
            value = self[key]
            # self.class.class_eval <<~RUBY, __FILE__, __LINE__ + 1
            #   def #{name} = self[#{key.inspect}]
            # RUBY
          end
          value
        end
      end

      def config = @config ||= Configurations.new
      def configure(**) = config.merge!(**)

      def initialize_copy(source)
        super
        @config = Configurations.new { |_h, k| source.config[k] }
      end

      module ClassHookMethods
        def inherited(subclass)
          super
          subclass.instance_variable_set(:@config, Configurations.new { |_h, k| config[k] })
        end
      end

      def self.extended(base)
        base.extend ClassHookMethods if base.is_a?(::Class)
      end

      module BoostMethods
        def call(&)
          mod, = @nesting
          deps[:module_config] = mod.config if mod.respond_to?(:config)

          super
        end
      end

      BindingExtension::Boost.include BoostMethods
    end
  end
end
