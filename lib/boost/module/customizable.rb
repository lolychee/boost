# frozen_string_literal: true

module Boost
  module Module
    module Customizable
      class Customization < ::Module
        module ClassMethods
          def customized_module_for(mod)
            modules = included_modules
            modules.unshift(self) unless is_a?(Class)
            modules.find { |m| m.respond_to?(:customized_for?) && m.customized_for?(mod) }
          end
        end

        def class_included(base)
          base.extend(ClassMethods)
        end
        alias class_prepend class_included

        def initialize(mod, ...)
          super()
          singleton_class.prepend(ClassHooks)
          extend(ClassMethods)
          include(@original = mod)
          return unless mod.instance_variable_defined?(:@_customizing_block)

          extend(::Module.new do
            private define_method(:setup!, &mod.instance_variable_get(:@_customizing_block))
          end)
          setup!(mod, ...)
        end

        def customized_for?(mod)
          @original.equal?(mod)
        end
      end

      def customizing(&block)
        @_customizing_block = block
      end

      def customize(...)
        Customization.new(self, ...)
      end
    end
  end
end
