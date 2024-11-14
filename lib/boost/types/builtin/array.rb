# frozen_string_literal: true

module Boost
  module Types
    module Builtin
      module Array
        include Enumerable::Is[::Array]
        extend self

        # def ===(other)
        #   binding.irb
        # end

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
          when *ZERO_PARAMS_METHODS then Callable::Return[value, key]
          when *BOOLEAN_METHODS     then Callable::Return[true, Callable::Send[key, *Array(value)]]
          else super
          end
        end
      end
    end
  end
end
