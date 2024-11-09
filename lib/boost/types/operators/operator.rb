# frozen_string_literal: true

module Boost
  module Types
    module Operators
      module Operator
        include Module::Customizable

        def ===(...)
          raise(TypeError, "do not use `#{name}` directly") unless defined?(@original)

          true
        end

        def initialize_customize(type) = @type = type
      end
    end
  end
end
