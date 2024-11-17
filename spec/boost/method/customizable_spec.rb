# frozen_string_literal: true

RSpec.describe Boost::Method::Customizable do
  subject(:mod) { |m = described_class| Module.new { extend m } }

  describe "CustomizedMethod" do
  end

  describe "customized_methods" do
    it { is_expected.to respond_to(:customized_methods) }
    it { expect(mod.customized_methods).to be_a(Hash) }
  end

  describe "#method_added" do
    it { is_expected.to respond_to(:method_added) }

    it "creates a CustomizedMethod for the method" do
      mod.class_eval { def foo; end }
      method = mod.customized_methods[:foo]

      expect(method).to be_a(Boost::Method::Customizable::CustomizedMethod)
      expect(method.name).to eq(:foo)
      expect(method.original_method).to be_a(UnboundMethod)
    end

    it "inject __module__ keyword argument" do
      mod.class_eval { def foo(__module__:) = __module__ }

      klass = Class.new
      klass.include mod
      expect(klass.new.foo).to eq(mod)
    end
  end
end
