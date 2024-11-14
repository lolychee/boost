# frozen_string_literal: true

RSpec.describe Boost::Method::Signaturable do
  describe "Signature" do
  end

  describe "BoostMethods" do
    let(:klass) do
      Class.new do
        def hello(a, b = nil, *, d:, e: nil, **)
          binding.boost.sig(String, nil, d: String, e: nil, return: Symbol) { :world }
        end
      end
    end

    let(:instance) { klass.new }

    it do
      expect(instance.hello("", nil, d: "", e: nil)).to eq(:world)
    end

    it do
      expect { instance.hello("", nil, d: nil, e: nil) }.to raise_error(TypeError)
    end
  end
end
