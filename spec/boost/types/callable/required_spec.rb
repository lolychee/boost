# frozen_string_literal: true

RSpec.describe Boost::Types::Callable::Required do
  it { is_expected.to respond_to(:===) }

  describe "#===" do
    it "raise NotImplementedError " do
      expect(described_class === Boost::Types::Callable::Required).to eq(true)
    end

    it { expect(described_class[Integer] === 1).to eq(true) }
    it { expect(described_class[Integer] === nil).to eq(false) }
  end
end
