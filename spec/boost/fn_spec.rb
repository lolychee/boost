# frozen_string_literal: true

RSpec.describe Boost::Fn do
  subject(:mod) { |m = described_class| Module.new { extend m } }

  it "define boost method with marco" do
    mod.class_eval do
      fn
      def foo; end
    end

    expect(mod.boost_methods).to include(:foo)
    expect(mod.fn(:foo)).to be_a(Boost::Method)
  end

  it "define boost method with block" do
    mod.class_eval do
      fn :foo do
        :foo
      end
    end

    expect(mod.boost_methods).to include(:foo)
    expect(mod.fn(:foo)).to be_a(Boost::Method)
  end

  context "with curried method" do
    it "define boost method with marco" do
      mod.class_eval do
        fn.curried(1, 2, 3, ka: 11, kb: 12, kc: 13)
        def foo(a, b, c, d, e, ka:, kb:, kc:, kd:, ke:)
          [a, b, c, d, e, ka, kb, kc, kd, ke]
        end
      end

      klass = Class.new
      klass.include mod

      expect(mod.boost_methods).to include(:foo)
      expect(mod.fn(:foo)).to be_a(Boost::Method)
      expect(klass.new.foo(4, 5, kd: 14, ke: 15)).to eq([1, 2, 3, 4, 5, 11, 12, 13, 14, 15])
    end

    it "define boost method with block" do
      mod.class_eval do
        fn(:foo).curried(1, 2, 3, ka: 11, kb: 12, kc: 13) do |a, b, c, d, e, ka:, kb:, kc:, kd:, ke:|
          [a, b, c, d, e, ka, kb, kc, kd, ke]
        end
      end

      klass = Class.new
      klass.include mod

      expect(mod.boost_methods).to include(:foo)
      expect(mod.fn(:foo)).to be_a(Boost::Method)
      expect(klass.new.foo(4, 5, kd: 14, ke: 15)).to eq([1, 2, 3, 4, 5, 11, 12, 13, 14, 15])
    end
  end
end
