# frozen_string_literal: true

RSpec.describe Boost::Types::Callable::Return do
  let(:required) { Boost::Types::Callable::Required }
  let(:send) { Boost::Types::Callable::Send }

  it { is_expected.to respond_to(:===) }

  describe "#===" do
    it { expect(described_class[true, :nil?] === nil).to be(true) }
    it { expect(described_class[true, send[:between?, 1, 5]] === 3).to be(true) }
  end
end
