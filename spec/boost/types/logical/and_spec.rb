# frozen_string_literal: true

RSpec.describe Boost::Types::Logical::And do
  it { expect(described_class).to respond_to(:===) }

  describe "#===" do
    it { expect(described_class.new(Integer, 1) === 1).to eq(true) }
  end
end
