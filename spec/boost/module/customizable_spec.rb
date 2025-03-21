# frozen_string_literal: true

RSpec.describe Boost::Module::Customizable do
  subject(:mod) do |m = described_class|
    Module.new do
      extend m
    end
  end

  it { is_expected.to respond_to(:customize) }
  it { is_expected.to respond_to(:customizing) }

  describe ".customizing" do
    it "stores a block for later customization" do
      block = -> {}
      mod.customizing(&block)
      expect(mod.instance_variable_get(:@_customizing_block)).to eq(block)
    end
  end

  describe ".customize" do
    it "returns a new module" do
      expect(mod.customize).to be_a(Module)
        .and include(mod)
    end

    it "creates a unique module for each customization" do
      customization1 = mod.customize
      customization2 = mod.customize
      expect(customization1).not_to eq(customization2)
    end

    it "properly integrates with ClassHooks" do
      customization = mod.customize
      expect(customization.singleton_class.ancestors).to include(Boost::Module::ClassHooks)
    end

    it "supports lookup via customized_module_for" do
      customization = mod.customize
      klass = Class.new { include customization }
      expect(klass.customized_module_for(mod)).to eq(customization)
    end

    context "when including in different class hierarchies" do
      let(:customization) { mod.customize }
      
      it "properly hooks into multiple classes" do
        class_inclusion_count = 0
        mod_customization = customization
        
        # Add class_included hook to the customization
        mod_customization.define_singleton_method(:class_included) do |_|
          class_inclusion_count += 1
        end
        
        # Include in multiple classes
        Class.new { include mod_customization }
        Class.new { include mod_customization }
        
        expect(class_inclusion_count).to eq(2)
      end

      it "works with class inheritance" do
        mod_customization = customization
        parent = Class.new { include mod_customization }
        child = Class.new(parent)
        
        expect(child.ancestors).to include(mod_customization)
      end
    end

    context "with attributes" do
      subject(:mod) do |m = described_class|
        Module.new do
          extend m
          $mod = self
          module ClassMethods
            def define_attribute(*names)
              mod = customized_module_for($mod) || self
              names.each do |name|
                mod.define_method("#{name}=") { |value| write_attribute(name, value) }
                mod.define_method(name) { read_attribute(name) }
              end
            end
          end

          class << self
            def included(base)
              base.extend(ClassMethods)
            end
            alias_method :class_included, :included
          end

          customizing do |_original, *attributes|
            define_attribute(*attributes)
          end

          def read_attribute(name)
            instance_variable_get("@#{name}")
          end

          def write_attribute(name, value)
            instance_variable_set("@#{name}", value)
          end
        end
      end

      it "adds attributes" do
        customization = mod.customize(:name)
        expect(customization.instance_methods).to include(:name, :name=)

        obj = Class.new { include customization }.new
        expect(obj).to respond_to(:name)
          .and respond_to(:name=)
        expect(obj.name).to be_nil
        expect { obj.name = "name" }.not_to raise_error
        expect(obj.name).to eq("name")
      end

      it "supports multiple attributes" do
        customization = mod.customize(:name, :email, :age)
        obj = Class.new { include customization }.new
        
        expect(obj).to respond_to(:name, :email, :age)
        expect(obj).to respond_to(:name=, :email=, :age=)
        
        obj.name = "John"
        obj.email = "john@example.com"
        obj.age = 30
        
        expect(obj.name).to eq("John")
        expect(obj.email).to eq("john@example.com")
        expect(obj.age).to eq(30)
      end

      it "isolates attributes between different customizations" do
        customization1 = mod.customize(:name)
        customization2 = mod.customize(:email)
        
        class1 = Class.new { include customization1 }
        class2 = Class.new { include customization2 }
        
        expect(class1.new).to respond_to(:name)
        expect(class1.new).not_to respond_to(:email)
        expect(class2.new).to respond_to(:email)
        expect(class2.new).not_to respond_to(:name)
      end
    end

    context "when prepending instead of including" do
      it "correctly hooks into the class" do
        customization = mod.customize
        prepend_hook_called = false
        
        customization.define_singleton_method(:class_prepended) do |_|
          prepend_hook_called = true
        end
        
        Class.new { prepend customization }
        expect(prepend_hook_called).to be true
      end
    end

    context "without customizing block" do
      it "still creates a valid customization" do
        # Create a module without customizing block
        plain_mod = Module.new do
          extend Boost::Module::Customizable
        end
        
        customization = plain_mod.customize
        expect { Class.new { include customization } }.not_to raise_error
      end
    end
  end

  describe "customized_for?" do
    it "correctly identifies original module" do
      customization = mod.customize
      expect(customization.customized_for?(mod)).to be true
      expect(customization.customized_for?(Module.new)).to be false
    end
  end
end
