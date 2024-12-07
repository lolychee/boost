# frozen_string_literal: true

module Boost
  module Types
    module Builtin
      class String
        include Type
        include Primitives
        extend Logical

        class << self
          def ===(other)
            ::String === other
          end
        end

        def initialize(**constraints)
          type = Is.new(self.class)
          type &= constraints.map { |k, v| build_constraint(k, v) }.inject(:&) if constraints.any?
          super(type)
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
          when *ZERO_PARAMS_METHODS then Send[key].returns(value)
          when *BOOLEAN_METHODS     then Send[key, *Array(value)].returns(true)
          else raise ArgumentError, "Unknown constraint: #{key}"
          end
        end
      end
    end
  end
end
