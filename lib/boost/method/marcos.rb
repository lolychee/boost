# frozen_string_literal: true

module Boost
  class Method
    module Marcos
      def self.extended(base)
        base.instance_variable_set(:@boost_methods, {})
      end

      def boost_methods
        @boost_methods.keys
      end

      def boost_method(*names)
        case names.size
        when 0
          @boost_method_enabled = true
          nil
        else
          names.each do |name|
            @boost_methods[name] ||= Method.new(self, instance_method(name)).tap(&:setup!)
          end
          names.size > 1 ? names : names.first
        end
      end

      def method_added(name)
        super
        boost_method(name) if @boost_method_enabled
      end
    end
  end
end
