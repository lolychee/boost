# frozen_string_literal: true

RSpec.describe Boost::Types::Builtin::Hash do
  it { is_expected.to respond_to(:===) }

  let(:key) { Boost::Types::Builtin::Hash::Key }

  describe "#===" do
    it { expect(described_class === {}).to eq(true) }
    it { expect(described_class === { foo: "bar" }).to eq(true) }
    it { expect(described_class[key[:asdf] => String]).to eq(true) }
  end
end
