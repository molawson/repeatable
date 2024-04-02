# typed: false
require "spec_helper"

module Repeatable
  module Expression
    describe Daily do
      subject { described_class.new }

      it_behaves_like "an expression"

      describe "#include?" do
        it "is true" do
          expect(subject).to include(::Date.new(2015, 1, 1))
        end
      end

      describe "#to_h" do
        it "returns a hash with the class name and arguments" do
          expect(subject.to_h).to eq(daily: {})
        end
      end

      describe "#==" do
        it "returns true" do
          expect(described_class.new).to eq(described_class.new)
        end
      end

      describe "#eql?" do
        it "returns true" do
          expect(described_class.new).to eql(described_class.new)
        end
      end
    end
  end
end
