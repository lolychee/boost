# frozen_string_literal: true

RSpec.describe Boost::Types::Callable::Send do
  it { is_expected.to respond_to(:===) }

  describe "#===" do
    it { expect(described_class[:nil?].call(nil)).to be(true) }
    it { expect(described_class[:between?, 1, 5, **{}, &-> {}].call(3)).to be(true) }
  end
end
