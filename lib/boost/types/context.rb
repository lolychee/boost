# frozen_string_literal: true

module Boost
  module Types
    class Context < ::Object
      include Primitives
      include Builtin

      # define Type(...) method instead of using the Type[...]
      # ref: https://bugs.ruby-lang.org/issues/19269
      Builtin.constants.each do |const|
        define_method(const) { |*args, **kwargs, &block| Builtin.const_get(const)[*args, **kwargs, &block] }
      end

      def self.T(&)
        raise ArgumentError, "no block given." unless block_given?

        return_type = And[KindOf[Type], Or[InstanceOf[::Module], InstanceOf[::Class]]]
        new.instance_eval(&).tap do |result|
          raise TypeError, "The block must return a type." unless return_type === result
        end
      end
    end
  end
end
