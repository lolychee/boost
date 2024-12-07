# frozen_string_literal: true

module Boost
  module Types
    module Primitives
      class Optional
        include Type
        extend Logical

        class << self
          def ===(other)
            true
          end
        end

        def initialize(type = Any)
          super
        end

        def ===(other)
          other.nil? || super
        end
      end
    end
  end
end
