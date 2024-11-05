# frozen_string_literal: true

RSpec.describe Boost::DependencyInjector do
  subject(:injector) { described_class.new(get_binding, deps) }

  let(:get_binding) { binding }

  let(:deps) { { foo: :bar, baz: -> { baz }, cat: proc { cat }, hello: :hello.to_proc } }
  let(:baz) { :qux }
  let(:cat) { :dog }

  it { is_expected.to respond_to(:block_call) }
  it { is_expected.to respond_to(:method_call) }

  describe "#block_call" do
    let(:hello) { :world }

    it "injects dependencies" do
      expect(injector.block_call { |foo, baz, cat:, hello:| [foo, baz, cat, hello] }).to eq(%i[bar qux dog world])
    end
  end

  describe "#method_call" do
    let(:klass) do
      Class.new do
        def get_binding = binding

        def run(foo, baz, cat:, hello:) = [foo, baz, cat, hello]

        def hello = :world
      end
    end

    let(:get_binding) { klass.new.get_binding }

    it "injects dependencies" do
      expect(injector.method_call(:run)).to eq(%i[bar qux dog world])
    end
  end
end
