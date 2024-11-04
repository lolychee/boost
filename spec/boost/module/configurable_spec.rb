# frozen_string_literal: true

RSpec.describe Boost::Module::Configurable do
  describe "Configurations" do
    subject(:config) { described_class::Configurations.new }

    it "accesses key with method" do
      config.foo = :bar
      expect(config.foo).to eq(:bar)
    end
  end

  describe "when extended by a Module" do
    subject(:mod) { |m = described_class| Module.new { extend m } }

    it { is_expected.to respond_to(:config) }
    it { is_expected.to respond_to(:configure) }

    it "works with clone" do
      mod.configure(foo: :bar)
      expect(mod.clone.config[:foo]).to eq(:bar)
    end

    it "works with dup" do
      mod.configure(foo: :bar)
      expect(mod.dup.config[:foo]).to eq(:bar)
    end
  end

  describe "when extended by a Class" do
    subject(:klass) { |m = described_class| Class.new { extend m } }

    it { is_expected.to respond_to(:config) }
    it { is_expected.to respond_to(:configure) }

    it "works with clone" do
      klass.configure(foo: :bar)
      expect(klass.clone.config[:foo]).to eq(:bar)
    end

    it "works with dup" do
      klass.configure(foo: :bar)
      expect(klass.dup.config[:foo]).to eq(:bar)
    end

    it "works with subclass" do
      klass.configure(foo: :bar)
      expect(Class.new(klass).config[:foo]).to eq(:bar)
    end
  end
end
