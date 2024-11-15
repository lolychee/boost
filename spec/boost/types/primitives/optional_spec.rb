# frozen_string_literal: true

RSpec.describe Boost::Types::Primitives::Optional do
  it { is_expected.to respond_to(:===) }

  describe "#===" do
    it "raise NotImplementedError " do
      expect(described_class === Boost::Types::Primitives::Optional).to eq(true)
    end

    it { expect(described_class[Integer] === 1).to eq(true) }
    it { expect(described_class[Integer] === nil).to eq(true) }
  end
end
