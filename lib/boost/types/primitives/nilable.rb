# frozen_string_literal: true

module Boost
  module Types
    module Primitives
      class Nilable
        include Type

        def initialize(type)
          super(Nil | type)
        end
      end
    end
  end
end
