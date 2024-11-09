# frozen_string_literal: true

RSpec.describe Boost::Dependencies do
  describe Boost::Dependencies::Registry do
    let(:deps) { described_class.new({ foo: :bar, baz: -> { baz }, cat: proc { cat }, hello: :hello.to_proc }) }
    let(:baz) { :qux }
    let(:cat) { :dog }

    it { is_expected.to respond_to(:call) }

    describe "#call" do
      context "when Proc" do
        let(:hello) { :world }

        let(:block) { ->(foo, baz, cat:, hello:) { [foo, baz, cat, hello] } }

        it "injects dependencies" do
          expect(deps.call(block)).to eq(%i[bar qux dog world])
        end
      end

      context "when Method" do
        let(:klass) do
          Class.new do
            def run(foo, baz, cat:, hello:) = [foo, baz, cat, hello]

            def hello = :world
          end
        end

        let(:method) { klass.new.method(:run) }

        it "injects dependencies" do
          expect(deps.call(method)).to eq(%i[bar qux dog world])
        end
      end
    end
  end
end
