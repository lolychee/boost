# frozen_string_literal: true

module Boost
  module Types
    module Primitives
      module Vars
        include Is
        extend self
        extend DoNotUseDirectly

        def initialize_customize(**kwargs)
          super(And[InstanceOf[::Binding], *kwargs.map do |name, type|
            if name.start_with?("@@")
              klass = Send[:receiver] >> Send[:class]
              And[
                Return[true, klass >> Send[:class_variable_defined?, name]],
                Return[type, klass >> Send[:class_variable_get, name]]
              ]
            elsif name.start_with?("@")
              receiver = Send[:receiver]
              And[
                Return[true, receiver >> Send[:instance_variable_defined?, name]],
                Return[type, receiver >> Send[:instance_variable_get, name]]
              ]
            elsif name.start_with?("$")
              And[
                Return[true, Send[:eval, "global_variables"] >> Send[:include?, name]],
                Return[type, Send[:eval, name.to_s]]
              ]
            else
              And[
                Return[true, Send[:local_variable_defined?, name]],
                Return[type, Send[:local_variable_get, name]]
              ]
            end
          end])
        end
      end
    end
  end
end
