# frozen_string_literal: true

module Boost
  module Types
    module Logical
      class Is
        include Type

        def initialize(type)
          @type = type
        end

        def ===(other)
          @type === other
        end

        def ==(other)
          instance_of?(other.class) && @type == other.instance_variable_get(:@type)
        end

        def !@
          Not.new(@type)
        end
      end
    end
  end
end