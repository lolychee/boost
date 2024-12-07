# frozen_string_literal: true

module Boost
  module Types
    module Logical
      def !@
        Not[self]
      end

      def |(other)
        Union[self, other]
      end

      def &(other)
        And[self, other]
      end
    end
  end
end
