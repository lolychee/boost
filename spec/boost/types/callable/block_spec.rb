# frozen_string_literal: true

RSpec.describe Boost::Types::Callable::Block do
  it { is_expected.to respond_to(:===) }

  describe "#===" do
    it "raise NotImplementedError " do
      expect(described_class === Boost::Types::Callable::Block).to eq(true)
    end

    it { expect(described_class === -> {}).to eq(true) }
    it { expect(described_class === method(:inspect).to_proc).to eq(true) }
  end
end
