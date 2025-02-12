module Boost
  module Marcos
    def boost_method(name = nil)
      @boost_methods ||= {}
      @boost_methods[name] ||= Method.decorate(instance_method(name))
    end

    module Fn
      include Marcos

      def fn
        @fn = Decorator::Chain.new(Method::DECORATOR_REGISTRY)
      end

      def method_added(name)
        super
        return unless @fn

        boost_method(name).tap do |m|
          m.fn = @fn
          @fn = nil
          m.refine!
        end
      end
    end
  end
end
