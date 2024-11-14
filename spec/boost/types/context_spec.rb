# frozen_string_literal: true

RSpec.describe Boost::Types::Context do
  describe ".T" do
    it { expect { described_class.T }.to raise_error(TypeError) }
    it { expect { described_class.T {} }.to raise_error(TypeError) }
    it { expect { described_class.T { nil } }.to raise_error(TypeError) }
    it { expect(described_class.T { Array(String) }).to eq(Boost::Types::Builtin::Array[String]) }
  end
end
