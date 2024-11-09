# frozen_string_literal: true

module Boost
  module Types
    module Primitives
      module Nilable
        include Primitive
        extend self

        def ===(other)
          raise TypeError, "do not use #{name} directly" unless defined?(@original)

          super || nil === other
        end
      end
    end
  end
end
