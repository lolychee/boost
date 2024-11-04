# frozen_string_literal: true

RSpec.describe Boost::BindingExtension do
  it "return a boost object" do
    expect(binding.boost).to be_a(Boost::BindingExtension::Boost)
  end
end
