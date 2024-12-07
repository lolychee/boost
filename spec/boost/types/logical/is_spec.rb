# frozen_string_literal: true

RSpec.describe Boost::Types::Logical::Is do
  it { expect(described_class).to respond_to(:===) }

  describe "#===" do
    it { expect(described_class.new(Integer) === 0).to eq(true) }
    it { expect(described_class.new(Integer) === nil).to eq(false) }
  end
end
