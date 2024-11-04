# frozen_string_literal: true

RSpec.describe Boost::Module::Customizable do
  describe "when extended by a Module" do
    subject do |mod = described_class|
      Module.new do
        extend Boost::Module::Configurable
        extend mod
      end
    end

    it { is_expected.to respond_to(:initialize_customize) }
    it { is_expected.to respond_to(:customize) }
    it { is_expected.to respond_to(:[]) }

    describe "#initialize_copy" do
      it "copies the configuration" do
        subject.configure(foo: :bar)
        clone = subject.clone
        subclone = clone.clone
        clone.configure(foo: :baz)
        expect(clone.config[:foo]).to eq(:baz)
        expect(subclone.config[:foo]).to eq(:bar)
      end

      it "set the original" do
        subject.configure(foo: :bar)
        clone = subject.clone
        subclone = clone.clone
        expect(clone.original).to eq(subject)
        expect(subclone.original).to eq(subject)
      end

      it "sets the temporary name" do
        subject.configure(foo: :bar)
        clone = subject.clone
        expect(clone.name).to eq("#{subject.name}[**customize**]")
      end
    end

    describe "#initialize_customize" do
      it "configures the clone" do
        subject.configure(foo: :bar)
        clone = subject.clone
        clone.initialize_customize(baz: :qux)

        expect(clone.config[:foo]).to eq(:bar)
        expect(clone.config[:baz]).to eq(:qux)
      end
    end
  end

  describe "when extended by a Class" do
    subject do |mod = described_class|
      Class.new do
        extend Boost::Module::Configurable
        extend mod
      end
    end

    it { is_expected.to respond_to(:initialize_customize) }
    it { is_expected.to respond_to(:customize) }
    it { is_expected.to respond_to(:[]) }

    describe "#initialize_copy" do
      it "copies the configuration" do
        subject.configure(foo: :bar)
        clone = subject.clone
        subclone = clone.clone
        clone.configure(foo: :baz)
        expect(clone.config[:foo]).to eq(:baz)
        expect(subclone.config[:foo]).to eq(:bar)
      end

      it "set the original" do
        subject.configure(foo: :bar)
        clone = subject.clone
        subclone = clone.clone
        expect(clone.original).to eq(subject)
        expect(subclone.original).to eq(subject)
      end

      it "sets the temporary name" do
        subject.configure(foo: :bar)
        clone = subject.clone
        expect(clone.name).to eq("#{subject.name}[**customize**]")
      end
    end
  end
end
