# frozen_string_literal: true

module Boost
  module Method
    module Toggleable
      include Customizable

      def enable_method(method_name)
        method = customized_methods[method_name] || return
        method.enable!
        method.setup!(self)
      end

      def disable_method(method_name)
        method = customized_methods[method_name] || return
        method.disable!
        method.setup!(self)
      end

      module CustomizedMethodExtension
        def enable! = @disabled = false
        def enabled? = !@disabled
        def disable! = @disabled = true
        def disabled? = @disabled

        def setup!(mod)
          enabled? ? super : mod.remove_method(name)
        end
      end

      Customizable::CustomizedMethod.include CustomizedMethodExtension
    end
  end
end
