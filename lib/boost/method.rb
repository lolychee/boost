# frozen_string_literal: true

module Boost
  module Method
    extend Decorator

    DECORATOR_REGISTRY = {
      curry: Method::Curry
    }

    include Bindable
    include Toggleable
  end
end
