# frozen_string_literal: true

module Boost
  module Types
    module Builtin
      class Hash < Enumerable
        def self.===(other)
          ::Hash === other
        end

        Key = ->(key) { Send[:[], key] }

        private

        BOOLEAN_METHODS = %i[
          include?
          intersect?
          eql?
          all?
          none?
          one?
          member?
          key?
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
