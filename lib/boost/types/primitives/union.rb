# frozen_string_literal: true

module Boost
  module Types
    module Primitives
      module Union
        include Primitive
        extend self

        def ===(other)
          raise TypeError, "do not use #{name} directly" unless defined?(@original)

          super
        end

        def initialize_customize(*types)
          super(Operators::Or[*types])
        end
      end
    end
  end
end
