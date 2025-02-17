# frozen_string_literal: true

RSpec.describe Boost::Marcos do
  subject(:mod) { Module.new.tap { |m| m.extend(described_class) } }

  before do
    mod.class_eval do
      def foo; end
    end
  end

  it "define boost method by boost_method" do
    expect(mod.boost_method(:foo)).to be_a(Boost::Method)
    expect(mod.instance_variable_get(:@boost_methods)).to include(:foo)
  end

  describe "::Fn" do
    let(:klass) { |m = mod| Class.new { include m } }

    it "define boost method with fn marco" do
      mod.class_eval do
        extend Boost::Marcos::Fn

        fn.curry(1, 2, 3, ka: 11, kb: 12, kc: 13)
        def foo(a, b, c, d, e, ka:, kb:, kc:, kd:, ke:)
          [a, b, c, d, e, ka, kb, kc, kd, ke]
        end
      end

      expect(klass.new.foo(4, 5, kd: 14, ke: 15)).to eq([1, 2, 3, 4, 5, 11, 12, 13, 14, 15])
    end

    it "applies decorators in the order they are defined" do
      mod.class_eval do
        extend Boost::Marcos::Fn

        fn
          .<< { |block| ["outer decorator start", *block.call, "outer decorator end"] }
          .<< { |block| ["inner decorator start", *block.call, "inner decorator end"] }
        def foo
          ["original method"]
        end
      end

      expect(klass.new.foo).to eq([
                                    "outer decorator start",
                                    "inner decorator start",
                                    "original method",
                                    "inner decorator end",
                                    "outer decorator end"
                                  ])
    end
  end
end
