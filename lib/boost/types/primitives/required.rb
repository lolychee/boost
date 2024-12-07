# frozen_string_literal: true

module Boost
  module Types
    module Primitives
      class Required
        include Type
        extend Logical

        class << self
          def ===(other)
            !other.nil?
          end
        end

        def initialize(type = Any)
          super
        end

        def ===(other)
          self.class === other && super
        end
      end
    end
  end
end
