# typed: false

require "spec_helper"

module Repeatable
  module Expression
    describe WeekdayInMonth do
      subject { described_class.new(weekday: 0, count: 1) }

      it_behaves_like "an expression"

      describe "#include?" do
        context "weekday matches" do
          it "returns true for dates matching the week given" do
            expect(subject).to include(::Date.new(2015, 1, 4))
          end

          it "returns false for dates not matching the week given" do
            expect(subject).not_to include(::Date.new(2015, 1, 11))
          end
        end

        context "weekday does not match" do
          it "returns false for dates matching the week given" do
            expect(subject).not_to include(::Date.new(2015, 1, 1))
          end

          it "returns false for dates not matching the week given" do
            expect(subject).not_to include(::Date.new(2015, 1, 12))
          end
        end
      end

      describe "#to_h" do
        it "returns a hash with the class name and arguments" do
          expect(subject.to_h).to eq(weekday_in_month: {weekday: 0, count: 1})
        end
      end

      describe "#==" do
        it "returns true if the expressions have the same arguments" do
          expect(described_class.new(weekday: 1, count: 2))
            .to eq(described_class.new(weekday: 1, count: 2))
        end

        it "returns false if the expressions have one differing argument" do
          expect(described_class.new(weekday: 1, count: 2))
            .not_to eq(described_class.new(weekday: 1, count: 3))
        end

        it "returns false if the given expression is not a WeekdayInMonth" do
          expect(described_class.new(weekday: 1, count: 2))
            .not_to eq(DayInMonth.new(day: 1))
        end
      end

      describe "#eql?" do
        let(:expression) { described_class.new(weekday: 1, count: 2) }

        it "returns true if the expressions have the same arguments" do
          other_expression = described_class.new(weekday: 1, count: 2)
          expect(expression).to eql(other_expression)
        end

        it "returns false if the expressions have one differing argument" do
          other_expression = described_class.new(weekday: 2, count: 3)
          expect(expression).not_to eql(other_expression)
        end

        it "returns false if the given expression is not a WeekdayInMonth" do
          other_expression = DayInMonth.new(day: 1)
          expect(expression).not_to eql(other_expression)
        end
      end

      describe "#hash" do
        let(:expression) { described_class.new(weekday: 1, count: 2) }

        it "of two expressions with the same arguments are the same" do
          other_expression = described_class.new(weekday: 1, count: 2)
          expect(expression.hash).to eq(other_expression.hash)
        end

        it "of two expressions with different arguments are not the same" do
          other_expression = described_class.new(weekday: 2, count: 3)
          expect(expression.hash).not_to eq(other_expression.hash)
        end

        it "of two expressions of different types are not the same" do
          other_expression = DayInMonth.new(day: 1)
          expect(expression.hash).not_to eq(other_expression.hash)
        end
      end

      describe "negative week" do
        context "last week" do
          subject { described_class.new(weekday: 3, count: -1) }

          it "matches valid dates" do
            expect(subject).to include(::Date.new(2017, 12, 27))
            expect(subject).to include(::Date.new(2017, 5, 31))
          end

          it "does not match invalid dates" do
            expect(subject).not_to include(::Date.new(2017, 12, 28))
            expect(subject).not_to include(::Date.new(2017, 5, 24))
          end
        end

        context "2nd to last week" do
          subject { described_class.new(weekday: 1, count: -2) }

          it "matches valid dates" do
            expect(subject).to include(::Date.new(2017, 12, 18))
            expect(subject).to include(::Date.new(2017, 5, 22))
          end

          it "does not match invalid dates" do
            expect(subject).not_to include(::Date.new(2017, 12, 27))
            expect(subject).not_to include(::Date.new(2017, 5, 31))
          end
        end
      end
    end
  end
end
