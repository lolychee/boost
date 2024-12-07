# frozen_string_literal: true

RSpec.describe Boost::Types::Primitives::Nilable do
  # it { is_expected.to respond_to(:===) }

  describe "#===" do
    it { expect(described_class[Integer] === 0).to eq(true) }
    it { expect(described_class[Integer] === nil).to eq(true) }
  end
end
