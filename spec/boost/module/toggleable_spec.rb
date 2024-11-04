# frozen_string_literal: true

RSpec.describe Boost::Module::Toggleable do
  describe "when extended by a Module" do
    subject { |mod = described_class| Module.new { extend mod } }

    it { is_expected.to respond_to(:on!) }
    it { is_expected.to respond_to(:on?) }
    it { is_expected.to respond_to(:off!) }
    it { is_expected.to respond_to(:off?) }

    it "works with clone" do
      subject.on!
      clone = subject.clone
      expect(clone.on?).to eq(true)
    end

    it "works with dup" do
      subject.on!
      clone = subject.dup
      expect(clone.on?).to eq(true)
    end

    it do
      module M
        extend Boost::Module::Toggleable

        def hello
          binding.boost do
            :hello
          end
        end
      end

      class C
        include M
      end
      c = C.new

      expect(c.hello).to eq(:hello)
      M.off!
      expect { c.hello }.to raise_error(NoMethodError)
      Object.send(:remove_const, :M)
      Object.send(:remove_const, :C)
    end
  end

  describe "when extended by a Class" do
    subject { |mod = described_class| Class.new { extend mod } }

    it { is_expected.to respond_to(:on!) }
    it { is_expected.to respond_to(:on?) }
    it { is_expected.to respond_to(:off!) }
    it { is_expected.to respond_to(:off?) }

    it "works with clone" do
      subject.on!
      clone = subject.clone
      expect(clone.on?).to eq(true)
    end

    it "works with dup" do
      subject.on!
      clone = subject.dup
      expect(clone.on?).to eq(true)
    end

    it "works with subclass" do
      subject.on!
      subclass = Class.new(subject)
      expect(subclass.on?).to eq(true)
    end

    it do
      class C
        extend Boost::Module::Toggleable

        def hello
          binding.boost do
            :hello
          end
        end
      end
      c = C.new

      expect(c.hello).to eq(:hello)
      C.off!
      expect { c.hello }.to raise_error(NoMethodError)
      Object.send(:remove_const, :C)
    end

    it do
      klass = Class.new do
        extend Boost::Module::Toggleable

        def hello
          binding.boost do |_dep|
            :hello
          end
        end
      end

      c = klass.new
      expect(c.hello).to eq(:hello)

      # expect { c.hello }.to output(/method defined in anonymous module or class, skipping/).to_stderr
    end
  end
end
