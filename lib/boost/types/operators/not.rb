# frozen_string_literal: true

module Boost
  module Types
    module Operators
      module Not
        include Operator
        extend self

        def ===(other) = super && !(@type === other)
      end
    end
  end
end
