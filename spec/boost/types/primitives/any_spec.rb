# frozen_string_literal: true

RSpec.describe Boost::Types::Primitives::Any do
  it { is_expected.to respond_to(:===) }

  describe "#===" do
    it { expect(described_class === 1).to eq(true) }
  end
end
