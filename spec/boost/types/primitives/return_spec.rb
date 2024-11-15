# frozen_string_literal: true

RSpec.describe Boost::Types::Primitives::Return do
  let(:required) { Boost::Types::Primitives::Required }
  let(:send) { Boost::Types::Primitives::Send }

  it { is_expected.to respond_to(:===) }

  describe "#===" do
    it { expect(described_class[true, :nil?] === nil).to be(true) }
    it { expect(described_class[true, send[:between?, 1, 5]] === 3).to be(true) }
  end
end
