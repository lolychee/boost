# frozen_string_literal: true

RSpec.describe Boost::Method::Toggleable do
  subject(:mod) { |m = described_class| Module.new }

  it "enables the method" do
    mod.class_eval { def foo = :foo }
    method = mod.instance_method(:foo)
    method.extend(described_class)
    method.refine!

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
    method = mod.instance_method(:foo)
    method.extend(described_class)
    method.refine!

    klass = Class.new
    klass.include mod

    method.disable!

    expect(mod.instance_methods).not_to include(:foo)
    expect { klass.new.foo }.to raise_error(NoMethodError)
  end
end
