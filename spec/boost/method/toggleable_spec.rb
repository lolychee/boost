# frozen_string_literal: true

RSpec.describe Boost::Method::Toggleable do
  subject(:mod) { |m = described_class| Module.new { extend m, Boost::Method::Customizable } }

  describe "#enable_method" do
    it { is_expected.to respond_to(:enable_method) }

    it "enables the method" do
      mod.class_eval { def foo = :foo }
      klass = Class.new
      klass.include mod

      mod.disable_method(:foo)

      expect(mod.instance_methods).not_to include(:foo)
      expect { klass.new.foo }.to raise_error(NoMethodError)

      mod.enable_method(:foo)

      expect(mod.instance_methods).to include(:foo)
      expect(klass.new.foo).to eq(:foo)
    end
  end

  describe "#disable_method" do
    it { is_expected.to respond_to(:enable_method) }

    it "disables the method" do
      mod.class_eval { def foo = :foo }
      klass = Class.new
      klass.include mod
      mod.disable_method(:foo)

      expect(mod.instance_methods).not_to include(:foo)
      expect { klass.new.foo }.to raise_error(NoMethodError)
    end
  end
end
