# frozen_string_literal: true

module Boost
  module Method
    module Signaturable
      class Signature
        def initialize(binding, *types, **kwtypes, &)
          @binding = binding
          @runtime_check = true

          @types = types.map { |type| required(type) }
          @kwtypes = kwtypes.filter_map do |name, type|
            case name
            when :return  then (@return  = required(type))  && next
            when :*       then (@rest    = required(Array)) && next
            when :**      then (@keyrest = required(Hash))  && next
            else
              name.end_with?("?") ? [name[...-1].to_sym, optional(type)] : [name, required(type)]
            end
          end.to_h
        end

        def runtime_check? = @runtime_check

        def call(&)
          return yield unless runtime_check?

          check_arguments!
          check_keywords!
          check_return!(yield)
        end

        protected

        def check_arguments!
          @types&.each_with_index do |type, i|
            next if type === @binding.local_variable_get(@binding.local_variables[i])

            raise TypeError, "Type Error: argument `#{name}` is not match #{type.inspect}"
          end
        end

        def check_keywords!
          @kwtypes&.each do |name, type|
            next if type === @binding.local_variable_get(name)

            raise TypeError, "Type Error: keyword `#{name}` is not match #{type.inspect}"
          end
        end

        def check_return!(value)
          return value if !defined?(@return) || @return === value

          raise TypeError, "Type Error: return value is not match #{@return.inspect}"
        end

        def required(type) = any_of(type)
        def optional(type) = any_of(type, NilClass)

        def any_of(*types)
          raise ArgumentError, "requires at least one argument" if types.empty?

          ->(value) { types.any? { |type| type === value } }
        end
      end

      module BoostMethods
        def call(&)
          defined?(@sig) ? @sig.call { super(&) } : super
        end

        def sig(*, **, &)
          @sig ||= Signature.new(deps[:binding], *, **)
          self_or_call(&)
        end
      end

      BindingExtension::Boost.include BoostMethods
    end
  end
end
