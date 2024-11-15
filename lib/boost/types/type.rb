# frozen_string_literal: true

module Boost
  module Types
    module Type
      include Module::Customizable

      def ==(other)
        if other.is_a?(Type)
          if original && other.original
            original == other.original
          elsif original
            original == other
          elsif other.original
            self == other.original
          else
            true
          end
        else
          super
        end
      end

      def to_proc = ->(this, other) { this === other || this == other }.curry(self)

      def self.cast(type)
        if type.is_a?(Primitives::Primitive)
          type
        elsif type.is_a?(::Module)
          Primitives::KindOf[type]
        else
          Primitives::Is[type]
        end
      end
    end
  end
end
