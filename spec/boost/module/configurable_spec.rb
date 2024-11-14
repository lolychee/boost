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
    subject(:mod) { |m = described_class| Module.new { extend m, Boost::Module::Customizable } }

    it { is_expected.to respond_to(:config) }
    it { is_expected.to respond_to(:configure) }

    it "works with clone" do
      mod.configure(foo: :bar)
      clone = mod.clone
      subclone = clone.clone
      clone.configure(foo: :baz)
      expect(clone.config[:foo]).to eq(:baz)
      expect(subclone.config[:foo]).to eq(:bar)
    end

    context "extended Customizable" do
      it "configures the clone" do
        mod.configure(foo: :bar)
        clone = mod.clone
        clone.initialize_customize(baz: :qux)

        expect(clone.config[:foo]).to eq(:bar)
        expect(clone.config[:baz]).to eq(:qux)
      end
    end
  end

  describe "when extended by a Class" do
    subject(:klass) { |m = described_class| Class.new { extend m, Boost::Module::Customizable } }

    it { is_expected.to respond_to(:config) }
    it { is_expected.to respond_to(:configure) }

    it "works with clone" do
      klass.configure(foo: :bar)
      expect(klass.clone.config[:foo]).to eq(:bar)
    end

    it "works with subclass" do
      klass.configure(foo: :bar)
      expect(Class.new(klass).config[:foo]).to eq(:bar)
    end

    context "extended Customizable" do
      it "configures the clone" do
        klass.configure(foo: :bar)
        clone = klass.clone
        clone.initialize_customize(baz: :qux)

        expect(clone.config[:foo]).to eq(:bar)
        expect(clone.config[:baz]).to eq(:qux)
      end
    end
  end
end
