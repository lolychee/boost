# frozen_string_literal: true

RSpec.describe Boost::Method::DependencyInject do
  let(:deps) { described_class.new({ foo: :bar, baz: -> { baz }, cat: proc { cat }, hello: :hello.to_proc }) }
  let(:baz) { :qux }
  let(:cat) { :dog }

  describe "#call" do
    context "when Proc" do
      let(:hello) { :world }

      let(:block) { ->(cat:, hello:) { [cat, hello] } }

      it "injects dependencies" do
        block.extend deps
        expect(block.call).to eq(%i[dog world])
      end
    end

    context "when Method" do
      let(:klass) do
        Class.new do
          def run(cat:, hello:) = [cat, hello]

          def hello = :world
        end
      end

      let(:method) { klass.new.method(:run) }

      it "injects dependencies" do
        method.extend deps
        expect(method.call).to eq(%i[dog world])
      end
    end
  end
end
