# frozen_string_literal: true

RSpec.describe Boost::Module::Toggleable do
  describe "when extended by a Module" do
    subject(:mod) { |m = described_class| Module.new { extend m } }

    it { is_expected.to respond_to(:on!) }
    it { is_expected.to respond_to(:on?) }
    it { is_expected.to respond_to(:off!) }
    it { is_expected.to respond_to(:off?) }

    describe "#off!" do
      before { mod.off! }

      it "works with clone" do
        expect(mod.clone.on?).to eq(false)
      end

      it "works with dup" do
        expect(mod.dup.on?).to eq(false)
      end

      it "raises NoMethodError if no super method is defined" do
        module M
          extend Boost::Module::Toggleable

          def hello = binding.boost { :hello }
        end

        klass = Class.new { include M }
        c = klass.new

        expect(c.hello).to eq(:hello)
        M.off!
        expect { c.hello }.to raise_error(NoMethodError)
        Object.send(:remove_const, :M)
      end
    end
  end

  describe "when extended by a Class" do
    subject(:klass) { |mod = described_class| Class.new { extend mod } }

    it { is_expected.to respond_to(:on!) }
    it { is_expected.to respond_to(:on?) }
    it { is_expected.to respond_to(:off!) }
    it { is_expected.to respond_to(:off?) }

    describe "#off!" do
      before { klass.off! }

      it "works with clone" do
        expect(klass.clone.on?).to eq(false)
      end

      it "works with dup" do
        expect(klass.dup.on?).to eq(false)
      end

      it "works with subclass" do
        expect(Class.new(klass).on?).to eq(true)
      end

      it "raises NoMethodError if no super method is defined" do
        class C
          extend Boost::Module::Toggleable

          def hello = binding.boost { :hello }
        end
        c = C.new

        expect(c.hello).to eq(:hello)
        C.off!
        expect { c.hello }.to raise_error(NoMethodError)
        Object.send(:remove_const, :C)
      end
    end

    it "return value if method defined in anonymous class" do
      klass = Class.new do
        extend Boost::Module::Toggleable

        def hello = binding.boost { |_dep| :hello }
      end

      c = klass.new
      expect(c.hello).to eq(:hello)

      # expect { c.hello }.to output(/method defined in anonymous module or class, skipping/).to_stderr
    end
  end
end
