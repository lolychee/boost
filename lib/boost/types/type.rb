# frozen_string_literal: true

module Boost
  module Types
    module Type
      include Module::Customizable

      def ==(other)
        if other.is_a?(Type)
          if __original__ && other.__original__
            __original__ == other.__original__
          elsif __original__
            __original__ == other
          elsif other.__original__
            self == other.__original__
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
