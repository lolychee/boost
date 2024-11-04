# frozen_string_literal: true

RSpec.describe Boost::Module::Configurable do
  describe "Configurations" do
    subject { described_class::Configurations.new }

    it "accesses key with method" do
      subject.foo = :bar
      expect(subject.foo).to eq(:bar)
    end
  end

  describe "when extended by a Module" do
    subject { |mod = described_class| Module.new { extend mod } }

    it { is_expected.to respond_to(:config) }
    it { is_expected.to respond_to(:configure) }

    it "works with clone" do
      subject.configure(foo: :bar)
      clone = subject.clone
      expect(clone.config[:foo]).to eq(:bar)
    end

    it "works with dup" do
      subject.configure(foo: :bar)
      clone = subject.dup
      expect(clone.config[:foo]).to eq(:bar)
    end
  end

  describe "when extended by a Class" do
    subject { |mod = described_class| Class.new { extend mod } }

    it { is_expected.to respond_to(:config) }
    it { is_expected.to respond_to(:configure) }

    it "works with clone" do
      subject.configure(foo: :bar)
      clone = subject.clone
      expect(clone.config[:foo]).to eq(:bar)
    end

    it "works with dup" do
      subject.configure(foo: :bar)
      clone = subject.dup
      expect(clone.config[:foo]).to eq(:bar)
    end

    it "works with subclass" do
      subject.configure(foo: :bar)
      subclass = Class.new(subject)
      expect(subclass.config[:foo]).to eq(:bar)
    end
  end
end
