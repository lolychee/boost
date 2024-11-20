# frozen_string_literal: true

RSpec.describe Boost::Method do
  subject(:mod) { |m = described_class| Module.new { extend m::Marcos } }

  it "creates a Boost::Method for the method" do
    mod.class_eval { def foo; end }
    method = described_class.new(mod)
    method.original_method = mod.instance_method(:foo)

    expect(method).to be_a(described_class)
    expect(method.name).to eq(:foo)
  end

  it "enables the method" do
    mod.class_eval { def foo = :foo }
    method = described_class.new(mod)
    method.original_method = mod.instance_method(:foo)
    method.setup!

    klass = Class.new
    klass.include mod

    method.disable!

    expect(mod.instance_methods).not_to include(:foo)
    expect { klass.new.foo }.to raise_error(NoMethodError)

    method.enable!

    expect(mod.instance_methods).to include(:foo)
    expect(klass.new.foo).to eq(:foo)
  end

  it "disables the method" do
    mod.class_eval { def foo = :foo }
    method = described_class.new(mod)
    method.original_method = mod.instance_method(:foo)
    method.setup!

    klass = Class.new
    klass.include mod

    method.disable!

    expect(mod.instance_methods).not_to include(:foo)
    expect { klass.new.foo }.to raise_error(NoMethodError)
  end
end
