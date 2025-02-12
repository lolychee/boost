# frozen_string_literal: true

RSpec.describe Boost::Decorator::Stack do
  subject(:stack) { described_class.new(initial_decorators) }

  let(:initial_decorators) { [] }
  let(:say_hello) { say_decorator("hello") }
  let(:say_hi) { say_decorator("hi") }
  let(:say_bye) { say_decorator("bye") }

  def say_decorator(say)
    ::Module.new do
      extend Boost::Decorator
      define_method(:call) do
        puts say
        super
      end
    end
  end

  describe "initialization and basic operations" do
    context "when empty stack" do
      it { is_expected.to be_empty }
      it { expect(stack.size).to eq(0) }
      it { expect(stack.last).to be_nil }
      it { expect(stack.first).to be_nil }
    end

    context "with initial decorators" do
      let(:initial_decorators) { [say_hi, say_bye] }

      it { expect(stack.size).to eq(2) }
      it { expect(stack.length).to eq(2) }
      it { expect(stack.last).to eq(say_bye) }
      it { expect(stack.first).to eq(say_hi) }
      it { is_expected.not_to be_empty }
    end

    describe "#push" do
      it "adds decorators to the end" do
        stack.push(say_hello, say_hi)
        expect(stack.size).to eq(2)
        expect(stack.last).to eq(say_hi)
      end

      it "supports chaining" do
        expect(stack.push(say_hello)).to eq(stack)
      end

      it "supports << alias" do
        stack << say_hello
        expect(stack.last).to eq(say_hello)
      end
    end

    describe "#pop" do
      let(:initial_decorators) { [say_hello, say_hi] }

      it "removes and returns the last decorator" do
        expect(stack.pop).to eq(say_hi)
        expect(stack.size).to eq(1)
      end

      it "returns nil when empty" do
        stack.pop
        stack.pop
        expect(stack.pop).to be_nil
      end
    end

    describe "#clear" do
      let(:initial_decorators) { [say_hello, say_hi] }

      it "removes all decorators" do
        stack.clear
        expect(stack).to be_empty
      end

      it "supports chaining" do
        expect(stack.clear).to eq(stack)
      end
    end
  end

  describe "index access" do
    let(:initial_decorators) { [say_hello, say_hi, say_bye] }

    describe "#[]" do
      it "accesses by positive index" do
        expect(stack[0]).to eq(say_hello)
        expect(stack[1]).to eq(say_hi)
        expect(stack[2]).to eq(say_bye)
      end

      it "accesses by negative index" do
        expect(stack[-1]).to eq(say_bye)
        expect(stack[-2]).to eq(say_hi)
      end

      it "returns nil for invalid index" do
        expect(stack[10]).to be_nil
        expect(stack[-10]).to be_nil
      end

      it "returns new stack for range" do
        result = stack[0..1]
        expect(result).to be_a(described_class)
        expect(result.size).to eq(2)
        expect(result[0]).to eq(say_hello)
      end
    end

    describe "#[]=" do
      let(:new_decorator) { say_decorator("new") }

      it "sets decorator at index" do
        stack[1] = new_decorator
        expect(stack[1]).to eq(new_decorator)
      end

      it "raises ArgumentError for non-integer index" do
        expect { stack["0"] = say_hello }.to raise_error(ArgumentError)
      end
    end
  end

  describe "replacement operations" do
    let(:initial_decorators) { [say_hello, say_hi, say_hello, say_bye] }
    let(:new_decorator) { say_decorator("new") }

    describe "#replace" do
      it "replaces by index" do
        stack.replace(1, new_decorator)
        expect(stack[1]).to eq(new_decorator)
      end

      it "replaces by equality" do
        stack.replace(say_hello, new_decorator)
        expect(stack[0]).to eq(new_decorator)
        expect(stack[2]).to eq(new_decorator)
      end

      it "supports chaining" do
        expect(stack.replace(0, new_decorator)).to eq(stack)
      end
    end
  end

  describe "enumeration" do
    let(:initial_decorators) { [say_hello, say_hi] }

    it "implements Enumerable" do
      expect(stack).to be_a(Enumerable)
    end

    it "yields each decorator" do
      decorators = []
      stack.each { |d| decorators << d }
      expect(decorators).to eq([say_hello, say_hi])
    end

    it "returns enumerator without block" do
      expect(stack.each).to be_a(Enumerator)
    end
  end

  describe "decoration" do
    let(:initial_decorators) { [say_hello, say_hi] }
    let(:object) { Object.new }

    it "includes decorators in reverse order" do
      decorated = stack.decorate(object)

      expect(decorated).to eq(object)
    end
  end
end
