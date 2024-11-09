# frozen_string_literal: true

RSpec.describe Boost::Types::Builtin::String do
  it { is_expected.to respond_to(:===) }

  describe "#===" do
    # binding.irb
    it { expect(described_class === "string").to eq(true) }
    it { expect(described_class[start_with?: "!"] === "!string").to eq(true) }
    it { expect(described_class[end_with?: "!"] === "string!").to eq(true) }
    it { expect(described_class[include?: "!"] === "string!string").to eq(true) }
    it { expect(described_class[length: ..5] === "str").to eq(true) }
    it { expect(described_class[length: 5..] === "string").to eq(true) }
    it { expect(described_class[length: 5] === "strin").to eq(true) }
    it { expect(described_class[next: "b"] === "a").to eq(true) }
  end
end
