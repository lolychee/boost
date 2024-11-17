# frozen_string_literal: true

module Boost
  module Method
    module Customizable
      class CustomizedMethod
        module Base
          attr_reader :name, :original_method

          def initialize(name = nil)
            @name = name
          end

          def name=(name)
            @name ||= name
          end

          def original_method=(method)
            @original_method ||= method
          end

          def bind_call(receiver, *args, **kwargs, &block)
            original_method.bind_call(receiver, *args, **kwargs, &block)
          end

          def resolve_dependencies(mod)
            original_method.parameters.filter_map do |type, name|
              case type
              when :keyreq, :key
                case name
                when :__module__ then [name, mod]
                end
              else next
              end
            end.to_h
          end

          def setup!(mod)
            return unless original_method

            this = self
            deps = resolve_dependencies(mod)
            mod.define_method(name) { |*args, **kwargs, &block| this.bind_call(self, *args, **kwargs, **deps, &block) }
          end
        end
        include Base
      end

      def customized_methods
        @customized_methods ||= {}
      end

      def method_added(method_name)
        super

        return if customized_methods.key?(method_name)

        (customized_methods[method_name] = (customized_methods.delete(nil) || CustomizedMethod.new).tap do |m|
          m.name = method_name
          m.original_method = instance_method(method_name)
        end).setup!(self)
      end
    end
  end
end
