# frozen_string_literal: true

module Boost
  module Types
    class Context < ::Object
      include Primitives
      include Builtin

      # define Type(...) method instead of using the Type[...]
      # ref: https://bugs.ruby-lang.org/issues/19269
      Builtin.constants.each do |const|
        type = Builtin.const_get(const)
        define_method(const) { |*args, **kwargs, &block| type[*args, **kwargs, &block] }
        define_method("#{const}?") { |*args, **kwargs, &block| Nilable[type[*args, **kwargs, &block]] }
      end

      RETURN_TYPE = (
        Send[:kind_of?, Type].returns(true) |
         (Send[:instance_of?, ::Module].returns(true) |
          Send[:instance_of?, ::Class].returns(true))
      ).freeze

      def self.T(&)
        raise ArgumentError, "no block given." unless block_given?

        new.instance_eval(&).tap do |result|
          raise TypeError, "The block must return a type." unless RETURN_TYPE === result
        end
      end
    end
  end
end
