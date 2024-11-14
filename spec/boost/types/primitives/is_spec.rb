# frozen_string_literal: true

RSpec.describe Boost::Types::Primitives::Is do
  it { is_expected.to respond_to(:===) }

  describe "#===" do
    it "raise TypeError" do
      expect { described_class === 0 }.to raise_error(TypeError)
    end

    it { expect(described_class[Integer] === 0).to eq(true) }
    it { expect(described_class[Integer] === nil).to eq(false) }
  end
end
