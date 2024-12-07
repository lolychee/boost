# frozen_string_literal: true

module Boost
  module Types
    module Primitives
      module Primitive
        include Type

        def initialize(type)
          @type = type
        end

        def ===(other)
          @type === other
        end
      end
    end
  end
end
