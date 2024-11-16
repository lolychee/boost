# frozen_string_literal: true

RSpec.describe Boost::Module::Customizable do
  describe "when extended by a module" do
    subject(:mod) do |m = described_class|
      Module.new { extend m }
    end

    it { is_expected.to respond_to(:initialize_customize) }
    it { is_expected.to respond_to(:customize) }
    it { is_expected.to respond_to(:[]) }

    describe "#initialize_copy" do
      it "sets the __original__" do
        clone = mod.clone
        subclone = clone.clone
        expect(clone.__original__).to eq(mod)
        expect(subclone.__original__).to eq(mod)
      end

      it "extends the Includable module" do
        expect(mod[foo: :bar].singleton_class < described_class::Includable).to eq(true)

        new_mod = Module.new { @abc = 123 }
        new_mod.include(mod[foo: :bar])
        expect(new_mod.instance_variable_get(:@abc)).to eq(123)
      end
    end

    describe "#customize" do
      it "leaves the name empty" do
        expect(mod[foo: :bar].name).to eq(nil)
      end

      it "sets the temporary name" do
        module M
          extend Boost::Module::Customizable
        end
        expect(M[1, 2, a: 3, b: 4, &-> {}].name).to eq("M[1, 2, :a=>3, :b=>4, &]")
        Object.send(:remove_const, :M)
      end
    end
  end

  describe "when extended by a class" do
    subject(:klass) do |m = described_class|
      Class.new { extend m }
    end

    it { is_expected.to respond_to(:initialize_customize) }
    it { is_expected.to respond_to(:customize) }
    it { is_expected.to respond_to(:[]) }

    describe "#initialize_copy" do
      it "sets the __original__" do
        clone = klass.clone
        subclone = clone.clone
        expect(clone.__original__).to eq(klass)
        expect(subclone.__original__).to eq(klass)
      end
    end

    describe "#customize" do
      it "leaves the name empty" do
        expect(klass[foo: :bar].name).to eq(nil)
      end

      it "sets the temporary name" do
        class C
          extend Boost::Module::Customizable
        end
        expect(C[1, 2, a: 3, b: 4, &-> {}].name).to eq("C[1, 2, :a=>3, :b=>4, &]")
        Object.send(:remove_const, :C)
      end
    end
  end
end
