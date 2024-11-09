# frozen_string_literal: true

module Boost
  module Types
    module Operators
      module Is
        include Operator
        extend self

        def ===(other) = super && @type === other
      end
    end
  end
end
