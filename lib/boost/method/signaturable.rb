# frozen_string_literal: true

module Boost
  module Method
    module Signaturable
      class Signature
        def initialize(binding)
          @binding = binding
          @runtime_check = true
        end

        def runtime_check? = @runtime_check

        def receives!(*types, **kwtypes)
          @types = types.map { |type| required(type) }
          @kwtypes = kwtypes.map do |name, type|
            if name[-1] == "?"
              [name[0..-2].to_sym, optional(type)]
            else
              [name, required(type)]
            end
          end.to_h
        end

        def returns!(type)
          @returns_type = required(type)
        end

        def call(&)
          return yield unless runtime_check?

          check_arguments!
          check_keywords!
          check_returns!(yield)
        end

        protected

        def check_arguments!
          @types&.each_with_index do |type, i|
            value = @binding.local_variable_get(@binding.local_variables[i])
            raise TypeError, "Type Error: argument `#{name}` is not match #{type.inspect}" unless type === value
          end
        end

        def check_keywords!
          @kwtypes&.each do |name, type|
            value = @binding.local_variable_get(name)
            raise TypeError, "Type Error: keyword `#{name}` is not match #{type.inspect}" unless type === value
          end
        end

        def check_returns!(value)
          return value if !defined?(@returns_type) || @returns_type === value

          raise TypeError, "Type Error: return value is not match #{type.inspect}"
        end

        def required(type) = any_of(type)
        def optional(type) = any_of(nil, type)

        def any_of(*types)
          raise ArgumentError, "requires at least one argument" if types.empty?

          ->(value) { types.any? { |type| type === value } }
        end
      end

      module BoostMethods
        def receives(*, **, &)
          signature.receives!(*, **)
          self_or_call(&)
        end

        def returns(*, **, &)
          signature.returns!(*, **)
          self_or_call(&)
        end

        def call(&)
          defined?(@signature) ? @signature.call { super(&) } : super
        end

        protected

        def signature = @signature ||= Signature.new(@binding)
      end

      BindingExtension::Boost.include BoostMethods
    end
  end
end
