# frozen_string_literal: true

RSpec.describe Boost::Types::Operators::Or do
  it { is_expected.to respond_to(:===) }

  describe "#===" do
    it "raise TypeError" do
      expect { described_class === "" }.to raise_error(TypeError)
    end

    it { expect(described_class[1, ""] === 1).to eq(true) }
  end
end
