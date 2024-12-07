# frozen_string_literal: true

module Boost
  module Types
    module Primitives
      module Any
        extend Type

        def self.===(_other)
          true
        end

        def self.==(_other)
          true
        end
      end
    end
  end
end
