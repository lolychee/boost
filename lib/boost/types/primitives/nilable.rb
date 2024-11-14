# frozen_string_literal: true

module Boost
  module Types
    module Primitives
      module Nilable
        include Is
        extend self
        extend Primitive::DoNotUseDirectly

        def ===(other)
          super || ::NilClass === other
        end
      end
    end
  end
end
