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

      Method::Signaturable

      def self.T(&block)
        return_type = Primitives::And[
          Primitives::KindOf[Type],
          Primitives::Or[
            Primitives::InstanceOf[::Module],
            Primitives::InstanceOf[::Class]
          ]
        ]
        binding.boost.sig(block: Primitives::Required[::Proc]) do
          new.instance_eval(&block).tap { |result| return_type === result }
        end
      end
    end
  end
end
