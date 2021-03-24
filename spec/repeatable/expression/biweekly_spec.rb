require "spec_helper"

module Repeatable
  module Expression
    describe Biweekly do
      subject { described_class.new(weekday: 1, start_after: ::Date.new(2015, 12, 1)) }

      it_behaves_like "an expression"

      describe "#include?" do
        context "included when" do
          it "first occurrence" do
            expect(subject).to include(::Date.new(2015, 12, 7))
          end

          it "first occurence in the next week" do
            expect(described_class.new(weekday: 5, start_after: ::Date.new(2015, 12, 1)))
              .to include(::Date.new(2015, 12, 4))
          end

          it "two weeks away from first occurrence" do
            expect(subject).to include(::Date.new(2015, 12, 21))
          end

          it "using start_after string" do
            expect(described_class.new(weekday: 1, start_after: "2015-12-1"))
              .to include(::Date.new(2015, 12, 21))
          end

          it "over year boundary" do
            expect(subject).to include(::Date.new(2016, 1, 4))
            expect(subject).to include(::Date.new(2016, 1, 18))
          end
        end

        context "not includes when" do
          it "on start_after date" do
            expect(described_class.new(weekday: 1, start_after: ::Date.new(2015, 12, 7)))
              .not_to include(::Date.new(2015, 12, 7))
          end

          it "only weekday matches" do
            expect(subject).not_to include(::Date.new(2015, 12, 14))
          end

          it "weekday does not match" do
            expect(subject).not_to include(::Date.new(2015, 12, 8))
          end

          it "before start_after date" do
            expect(subject).not_to include(::Date.new(2015, 11, 23))
          end
        end
      end

      describe "#to_h" do
        it "returns a hash with the class name and arguments with a date string" do
          expect(subject.to_h).to eq(biweekly: {weekday: 1, start_after: "2015-12-01"})
          expect(described_class.new(weekday: 1).to_h)
            .to eq(biweekly: {weekday: 1, start_after: ::Date.today.to_s})
        end
      end

      describe "#eql?" do
        let(:expression) { described_class.new(weekday: 1, start_after: ::Date.new(2015, 12, 1)) }

        it "returns true if the expressions have the same arguments" do
          other_expression = described_class.new(weekday: 1, start_after: ::Date.new(2015, 12, 1))
          expect(expression).to eql(other_expression)
        end

        it "returns true if one expression uses the string version of the start_after" do
          other_expression = described_class.new(weekday: 1, start_after: "2015-12-1")
          expect(expression).to eql(other_expression)
        end

        it "returns true if the start_after is Date.today (explicit default) for one and not given for the other" do
          expression = described_class.new(weekday: 1, start_after: ::Date.today)
          other_expression = described_class.new(weekday: 1)
          expect(expression).to eql(other_expression)
        end

        it "returns false if the expressions have one differing argument" do
          other_expression = described_class.new(weekday: 2, start_after: ::Date.new(2015, 12, 1))
          expect(expression).not_to eql(other_expression)
        end

        it "returns false if the given expression is not a WeekdayInMonth" do
          other_expression = DayInMonth.new(day: 1)
          expect(expression).not_to eql(other_expression)
        end
      end
    end
  end
end
