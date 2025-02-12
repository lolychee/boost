# frozen_string_literal: true

RSpec.describe Boost::Method do
  subject(:mod) { Module.new }

  let(:klass) { |m = mod| Class.new { include m } }
end
