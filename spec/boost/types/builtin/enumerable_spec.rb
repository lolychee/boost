# frozen_string_literal: true

RSpec.describe Boost::Types::Builtin::Enumerable do
  it { is_expected.to respond_to(:===) }

  describe "#===" do
    it { expect(described_class === []).to eq(true) }
    it { expect(described_class[2] === [:foo, "bar"]).to eq(true) }
    it { expect(described_class[..5] === [1, :b, "c"]).to eq(true) }
    it { expect(described_class[5..] === [1, :b, "c", 4.0, /5/, :six.to_proc]).to eq(true) }

    it { expect(described_class[String,  2] === %w[foo bar]).to eq(true) }
    it { expect(described_class[Integer, ..5] === [1, 2, 3]).to eq(true) }
    it { expect(described_class[Integer, 5..] === [1, 2, 3, 4, 5, 6]).to eq(true) }

    it { expect(described_class[0 => Integer, 1 => String] === [1, "2"]).to eq(true) }
    it { expect(described_class[..3 => Integer] === [1, 2, 3, 4, 5, 6]).to eq(true) }
    it { expect(described_class[..3 => Integer] === [1, 2, 3, "4"]).to eq(false) }
  end
end
