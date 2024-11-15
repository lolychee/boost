# frozen_string_literal: true

module Boost
  module Types
    module Primitives
      module Nilable
        include Is
        extend self
        extend DoNotUseDirectly

        def ===(other)
          super || other.nil?
        end
      end
    end
  end
end
