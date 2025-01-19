# frozen_string_literal: true

RSpec.describe Boost::Method::Curry do
  subject(:mod) { Module.new }

  let(:klass) { |m = mod| Class.new { include m } }

  it "define boost method with marco" do
    mod.class_eval do
      def foo(a, b, c, d, e, ka:, kb:, kc:, kd:, ke:)
        [a, b, c, d, e, ka, kb, kc, kd, ke]
      end
    end

    decorator = described_class.new(1, 2, 3, ka: 11, kb: 12, kc: 13)
    method = decorator.decorate(klass.new.method(:foo), wrapper: nil)

    expect(method[4, 5, kd: 14, ke: 15]).to eq([1, 2, 3, 4, 5, 11, 12, 13, 14, 15])
    expect(method.call(4, 5, kd: 14, ke: 15)).to eq([1, 2, 3, 4, 5, 11, 12, 13, 14, 15])
    expect(method.to_proc.call(4, 5, kd: 14, ke: 15)).to eq([1, 2, 3, 4, 5, 11, 12, 13, 14, 15])
  end
end
