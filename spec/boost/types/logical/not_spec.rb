# frozen_string_literal: true

RSpec.describe Boost::Types::Logical::Not do
  it { expect(described_class).to respond_to(:===) }

  describe "#===" do
    it { expect(described_class.new(nil) === 1).to eq(true) }
  end
end
