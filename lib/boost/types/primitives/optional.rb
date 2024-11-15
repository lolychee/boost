# frozen_string_literal: true

module Boost
  module Types
    module Primitives
      module Optional
        include Nilable[Any]
        extend self
      end
    end
  end
end
