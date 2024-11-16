# frozen_string_literal: true

RSpec.describe Boost::Dependencies do
  let(:deps) { described_class.new({ foo: :bar, baz: -> { baz }, cat: proc { cat }, hello: :hello.to_proc }) }
  let(:baz) { :qux }
  let(:cat) { :dog }

  it { is_expected.to respond_to(:call) }

  describe "#call" do
    context "when Proc" do
      let(:hello) { :world }

      let(:block) { ->(cat:, hello:) { [cat, hello] } }

      it "injects dependencies" do
        expect(deps.call(block)).to eq(%i[dog world])
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
        expect(deps.call(method)).to eq(%i[dog world])
      end
    end
  end
end
