# frozen_string_literal: true

module Boost
  module Types
    module Primitives
      module Primitive
        include Type

        module DoNotUseDirectly
          def ===(...)
            raise(TypeError, "do not use `#{name}` directly") unless defined?(@original)

            super
          end
        end

        def ===(other) = @type === other

        def initialize_customize(type) = @type = type
      end
    end
  end
end
