# frozen_string_literal: true

module Boost
  module Types
    module Primitives
      module InstanceOf
        include Primitive
        extend self
        extend DoNotUseDirectly

        def ===(other) = super && other.instance_of?(@type)
      end
    end
  end
end
