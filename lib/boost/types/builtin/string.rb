# frozen_string_literal: true

module Boost
  module Types
    module Builtin
      module String
        include Primitives::Is[::String]
        extend self

        def initialize_customize(**constraints)
          super(constraints.any? ? Primitives::And[@type, *constraints.map { |k, v| build_constraint(k, v) }] : @type)
        end

        private

        ZERO_PARAMS_METHODS = %i[
          encoding
          b
          next
          bytesize
          chr
          hash
          length
          size
          hex
          oct
          intern
          ord
          valid_encoding?
          ascii_only?
          empty?
          frozen?
          nil?
        ].freeze

        BOOLEAN_METHODS = %i[
          unicode_normalized?
          include?
          eql?
          casecmp?
          match?
          start_with?
          end_with?
          between?
          equal?
        ].freeze

        def build_constraint(key, value)
          case key
          when *ZERO_PARAMS_METHODS then Primitives::Return[value, key]
          when *BOOLEAN_METHODS     then Primitives::Return[true, Primitives::Send[key, *Array(value)]]
          else raise ArgumentError, "Unknown constraint: #{key}"
          end
        end
      end
    end
  end
end
