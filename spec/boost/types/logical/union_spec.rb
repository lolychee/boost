# frozen_string_literal: true

RSpec.describe Boost::Types::Logical::Union do
  it { expect(described_class).to respond_to(:===) }

  describe "#===" do
    it { expect(described_class.new(1, "") === 1).to eq(true) }
  end
end
