# frozen_string_literal: true

RSpec.describe Boost::Module::Customizable do
  describe "when extended by a Module" do
    subject(:mod) do |m = described_class|
      Module.new { extend Boost::Module::Configurable, m }
    end

    it { is_expected.to respond_to(:initialize_customize) }
    it { is_expected.to respond_to(:customize) }
    it { is_expected.to respond_to(:[]) }

    describe "#initialize_copy" do
      it "copies the configuration" do
        mod.configure(foo: :bar)
        clone = mod.clone
        subclone = clone.clone
        clone.configure(foo: :baz)
        expect(clone.config[:foo]).to eq(:baz)
        expect(subclone.config[:foo]).to eq(:bar)
      end

      it "set the original" do
        clone = mod.clone
        subclone = clone.clone
        expect(clone.original).to eq(mod)
        expect(subclone.original).to eq(mod)
      end

      it "sets the temporary name" do
        expect(mod.clone.name).to eq("#{mod.name}[**customize**]")
      end
    end

    describe "#initialize_customize" do
      it "configures the clone" do
        mod.configure(foo: :bar)
        clone = mod.clone
        clone.initialize_customize(baz: :qux)

        expect(clone.config[:foo]).to eq(:bar)
        expect(clone.config[:baz]).to eq(:qux)
      end
    end

    # it do
    #   binding.irb
    # end
  end

  describe "when extended by a Class" do
    subject(:klass) do |m = described_class|
      Class.new { extend Boost::Module::Configurable, m }
    end

    it { is_expected.to respond_to(:initialize_customize) }
    it { is_expected.to respond_to(:customize) }
    it { is_expected.to respond_to(:[]) }

    describe "#initialize_copy" do
      it "copies the configuration" do
        klass.configure(foo: :bar)
        clone = klass.clone
        subclone = clone.clone
        clone.configure(foo: :baz)
        expect(clone.config[:foo]).to eq(:baz)
        expect(subclone.config[:foo]).to eq(:bar)
      end

      it "set the original" do
        clone = klass.clone
        subclone = clone.clone
        expect(clone.original).to eq(klass)
        expect(subclone.original).to eq(klass)
      end

      it "sets the temporary name" do
        expect(klass.clone.name).to eq("#{klass.name}[**customize**]")
      end
    end
  end
end
