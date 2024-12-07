# frozen_string_literal: true

module Boost
  module Types
    module Primitives
      class Vars
        include Type

        def initialize(**constraints)
          type = Send[:instance_of?, ::Binding].returns(true)
          type &= constraints.map { |k, v| build_constraint(k, v) }.inject(:&) if constraints.any?
          super(type)
        end

        private

        def build_constraint(key, value)
          if key.start_with?("@@")
            klass = Send[:receiver] >> Send[:class]
            (klass >> Send[:class_variable_defined?, key]).returns(true) &
              (klass >> Send[:class_variable_get, key]).returns(value)
          elsif key.start_with?("@")
            receiver = Send[:receiver]
            (receiver >> Send[:instance_variable_defined?, key]).returns(true) &
              (receiver >> Send[:instance_variable_get, key]).returns(value)
          elsif key.start_with?("$")
            (Send[:eval, "global_variables"] >> Send[:include?, key]).returns(true) &
              Send[:eval, key.to_s].returns(value)
          else
            Send[:local_variable_defined?, key].returns(true) &
              Send[:local_variable_get, key].returns(value)
          end
        end
      end
    end
  end
end
