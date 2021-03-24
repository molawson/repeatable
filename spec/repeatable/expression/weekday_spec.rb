require "spec_helper"

module Repeatable
  module Expression
    describe Weekday do
      subject { described_class.new(weekday: 4) }

      it_behaves_like "an expression"

      describe "#include?" do
        it "returns true for dates matching the weekday given" do
          expect(subject).to include(::Date.new(2015, 1, 1))
        end

        it "returns false for dates not matching the weekday given" do
          expect(subject).not_to include(::Date.new(2015, 1, 2))
        end
      end

      describe "#to_h" do
        it "returns a hash with the class name and arguments" do
          expect(subject.to_h).to eq(weekday: {weekday: 4})
        end
      end

      describe "#==" do
        it "returns true if the expressions have the same argument" do
          expect(described_class.new(weekday: 1)).to eq(described_class.new(weekday: 1))
        end

        it "returns false if the expressions do not have the same argument" do
          expect(described_class.new(weekday: 1)).not_to eq(described_class.new(weekday: 2))
        end

        it "returns false if the given expression is not a Weekday" do
          expect(described_class.new(weekday: 1)).not_to eq(DayInMonth.new(day: 1))
        end
      end

      describe "#eql?" do
        let(:expression) { described_class.new(weekday: 1) }

        it "returns true if the expressions have the same argument" do
          other_expression = described_class.new(weekday: 1)
          expect(expression).to eql(other_expression)
        end

        it "returns false if the expressions do not have the same argument" do
          other_expression = described_class.new(weekday: 2)
          expect(expression).not_to eql(other_expression)
        end

        it "returns false if the given expression is not a Weekday" do
          other_expression = DayInMonth.new(day: 1)
          expect(expression).not_to eql(other_expression)
        end
      end

      describe "#hash" do
        let(:expression) { described_class.new(weekday: 1) }

        it "of two expressions with the same arguments are the same" do
          other_expression = described_class.new(weekday: 1)
          expect(expression.hash).to eq(other_expression.hash)
        end

        it "of two expressions with different arguments are not the same" do
          other_expression = described_class.new(weekday: 2)
          expect(expression.hash).not_to eq(other_expression.hash)
        end

        it "of two expressions of different types are not the same" do
          other_expression = DayInMonth.new(day: 1)
          expect(expression.hash).not_to eq(other_expression.hash)
        end
      end
    end
  end
end
