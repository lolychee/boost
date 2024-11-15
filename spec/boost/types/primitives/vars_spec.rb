# frozen_string_literal: true

RSpec.describe Boost::Types::Primitives::Vars do
  it { is_expected.to respond_to(:===) }

  it do
    a = ""
    b = nil
    d = ""
    e = nil

    @a = ""
    @b = nil

    self.class.class_variable_set(:@@a, "")
    self.class.class_variable_set(:@@b, nil)

    $a = ""
    $b = nil

    expect(described_class[
      a: String,
      b: nil,
      d: String,
      e: nil,
      :@a => String,
      :@b => nil,
      :@@a => String,
      :@@b => nil,
      :$a => String,
      :$b => nil,
      ] === binding).to eq(true)
  end

  it do
    a = ""
    b = nil
    d = ""
    e = nil

    @a = ""
    @b = nil

    self.class.class_variable_set(:@@a, "")
    self.class.class_variable_set(:@@b, nil)

    $a = ""
    $b = nil

    expect(described_class[a: nil, b: nil,] === binding).to eq(false)
    expect(described_class[:@a => nil, :@b => nil] === binding).to eq(false)
    expect(described_class[:@@a => nil, :@@b => nil] === binding).to eq(false)
    expect(described_class[:$a => nil, :$b => nil] === binding).to eq(false)
  end
end
