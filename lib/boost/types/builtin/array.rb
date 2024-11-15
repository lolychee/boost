# frozen_string_literal: true

module Boost
  module Types
    module Builtin
      module Array
        include Enumerable::Abstract[::Array]
        extend self

        private

        ZERO_PARAMS_METHODS = %i[
          empty?
          any?
        ].freeze

        BOOLEAN_METHODS = %i[
          include?
          intersect?
          eql?
          all?
          none?
          one?
          member?
        ].freeze

        def build_constraint(key, value)
          case key
          when *ZERO_PARAMS_METHODS then Primitives::Return[value, key]
          when *BOOLEAN_METHODS     then Primitives::Return[true, Primitives::Send[key, *Array(value)]]
          else super
          end
        end
      end
    end
  end
end
