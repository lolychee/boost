# frozen_string_literal: true

module Boost
  module Types
    module Builtin
      class Enumerable
        include Type
        include Primitives
        extend Logical

        class << self
          def ===(other)
            ::Enumerable === other
          end
        end

        private

        SIZE_TYPE = (Send[:instance_of?, ::Integer].returns(true) | Send[:instance_of?, ::Range].returns(true)).freeze

        def initialize(value_type = nil, size = nil, **constraints)
          type = Is.new(self.class)
          if size.nil? && SIZE_TYPE === value_type
            size = value_type
            value_type = nil
          end

          type &= Send[:size].returns(size) unless size.nil?
          type &= Send[:all?, value_type].returns(true) unless value_type.nil?
          type &= constraints.map { |k, v| build_constraint(k, v) }.inject(:&) if constraints.any?
          super(type)
        end

        ZERO_PARAMS_METHODS = %i[
          length
          size
          count
          empty?
          any?
        ].freeze

        def build_constraint(key, value)
          case key
          when Integer then Send[:[], key].returns(value)
          when Range   then (Send[:[], key] >> Send[:all?, value]).returns(true)

          when *ZERO_PARAMS_METHODS then Send[key].returns(value)
          when Send then key.returns(value)
          else raise ArgumentError, "Unsupported constraint: #{key}"
          end
        end
      end
    end
  end
end
