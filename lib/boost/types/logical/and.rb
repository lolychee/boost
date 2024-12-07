# frozen_string_literal: true

module Boost
  module Types
    module Logical
      class And
        include Type

        def initialize(*types)
          raise ArgumentError, "At least two types are required" if types.size < 2

          @types = types.map { |type| Type.cast(type) }
        end

        def ===(other)
          @types.all? { |type| type === other }
        end

        def ==(other)
          instance_of?(other.class) && @types == other.instance_variable_get(:@types)
        end

        def &(other)
          dup.tap do |new|
            if other.instance_of?(self.class)
              new.instance_variable_get(:@types).push(*other.instance_variable_get(:@types))
            else
              new.instance_variable_get(:@types) << other
            end
          end
        end
      end
    end
  end
end
