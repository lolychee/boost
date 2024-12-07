# frozen_string_literal: true

module Boost
  module Types
    module Builtin
      class Array < Enumerable
        def self.===(other)
          ::Array === other
        end

        private

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
          when *BOOLEAN_METHODS then Send[key, *Array(value)].returns(true)
          else super
          end
        end
      end
    end
  end
end
