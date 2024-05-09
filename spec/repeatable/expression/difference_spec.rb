# typed: false

require "spec_helper"

module Repeatable
  module Expression
    describe Difference do
      let(:mondays) { Repeatable::Expression::Weekday.new(weekday: 1) }
      let(:fourths) { Repeatable::Expression::DayInMonth.new(day: 4) }
      let(:elevenths) { Repeatable::Expression::DayInMonth.new(day: 11) }
      let(:union) { Repeatable::Expression::Union.new(fourths, elevenths) }

      subject { described_class.new(included: mondays, excluded: union) }

      it_behaves_like "an expression"

      describe "#include?" do
        it "returns true for dates that were not excluded" do
          expect(subject).to include(::Date.new(2016, 6, 27))
          expect(subject).to_not include(::Date.new(2016, 7, 4))
          expect(subject).to_not include(::Date.new(2016, 7, 11))
          expect(subject).to include(::Date.new(2016, 7, 18))
        end
      end

      describe "#to_h" do
        it "serializes all the way down" do
          expect(subject.to_h).to eql({
            difference: {
              included: {weekday: {weekday: 1}},
              excluded: {
                union: [
                  {day_in_month: {day: 4}},
                  {day_in_month: {day: 11}}
                ]
              }
            }
          })
        end
      end

      describe "#==" do
        it "returns true for the same expressions" do
          other_expression = described_class.new(included: mondays, excluded: union)
          expect(subject).to eq(other_expression)
        end

        it "returns false for different expressions" do
          other_expression = described_class.new(included: mondays, excluded: fourths)
          expect(subject).to_not eq(other_expression)
        end

        it "returns false for a different class of expression" do
          expect(subject).to_not eq(mondays)
        end
      end
    end
  end
end
