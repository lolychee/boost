# frozen_string_literal: true

RSpec.describe Boost::Types::Callable::Parameters do
  let(:required) { Boost::Types::Callable::Required }
  let(:optional) { Boost::Types::Callable::Optional }

  it { is_expected.to respond_to(:===) }

  describe "#===" do
    it "raise NotImplementedError " do
      expect(described_class === -> {}).to eq(true)
    end

    it { expect(described_class[required] === ->(a) {}).to eq(true) }
    it { expect(described_class[required, optional] === ->(a) {}).to eq(false) }
    it { expect(described_class[required, optional] === ->(a, b = 2, c = 3) {}).to eq(true) }
  end
end
