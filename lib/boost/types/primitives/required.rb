# frozen_string_literal: true

module Boost
  module Types
    module Primitives
      module Required
        include Is[Not[NilClass]]
        extend self
      end
    end
  end
end
