# frozen_string_literal: true

RSpec.describe Boost::Types::Primitives::Respond do
  let(:required) { Boost::Types::Primitives::Required }

  it { is_expected.to respond_to(:===) }

  describe "#===" do
    it "returns true when other responds to the method" do
      expect(described_class[:nil?] === nil).to be(true)
    end

    it { expect(described_class[:between?, required, required] === 3).to be(true) }
  end
end
