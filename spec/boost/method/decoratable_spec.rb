# frozen_string_literal: true

RSpec.describe Boost::Method::Decoratable do
  subject(:mod) { |m = described_class| Module.new { extend m } }

  let(:klass) { |m = mod| Class.new { include m } }

  it "define boost method with marco" do
    mod.class_eval do
      def foo(a, b, c, d, e, ka:, kb:, kc:, kd:, ke:)
        [a, b, c, d, e, ka, kb, kc, kd, ke]
      end
    end

    boost_method = Boost::Method.new
    boost_method.original_method = mod.instance_method(:foo)
    boost_method.curry(1, 2, 3, ka: 11, kb: 12, kc: 13)

    expect(boost_method.bind(klass.new).call(4, 5, kd: 14, ke: 15)).to eq([1, 2, 3, 4, 5, 11, 12, 13, 14, 15])
  end
end
