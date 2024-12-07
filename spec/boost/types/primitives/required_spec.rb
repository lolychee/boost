# frozen_string_literal: true

RSpec.describe Boost::Types::Primitives::Required do
  it { is_expected.to respond_to(:===) }

  describe "#===" do
    it { expect(described_class[Integer] === 1).to eq(true) }
    it { expect(described_class[Integer] === nil).to eq(false) }
  end
end
