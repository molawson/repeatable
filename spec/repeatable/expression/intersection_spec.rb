require "spec_helper"

module Repeatable
  module Expression
    describe Intersection do
      let(:twenty_third) { Repeatable::Expression::DayInMonth.new(day: 23) }
      let(:oct_thru_dec) { Repeatable::Expression::RangeInYear.new(start_month: 10, end_month: 12) }

      subject { described_class.new(twenty_third, oct_thru_dec) }

      it_behaves_like "an expression"

      describe "#initialize" do
        context "when there are no Intersection elements" do
          subject { described_class.new(twenty_third) }

          it "returns all elements as is" do
            expected_hash = {intersection: [{day_in_month: {day: 23}}]}
            expect(subject.to_h).to eq(expected_hash)
          end
        end

        context "when there are Intersection elements" do
          subject { described_class.new(twenty_third).intersection(oct_thru_dec) }

          specify do
            expected_hash = {
              intersection: [
                {day_in_month: {day: 23}},
                {range_in_year: {start_month: 10, end_month: 12}}
              ]
            }
            expect(subject.to_h).to eq(expected_hash)
          end
        end
      end

      describe "#include?" do
        it "only returns true for dates that match all expressions" do
          expect(subject.include?(::Date.new(2015, 9, 23))).to eq(false)
          expect(subject.include?(::Date.new(2015, 10, 2))).to eq(false)
          expect(subject.include?(::Date.new(2015, 10, 23))).to eq(true)
          expect(subject.include?(::Date.new(2015, 11, 23))).to eq(true)
          expect(subject.include?(::Date.new(2015, 12, 23))).to eq(true)
          expect(subject.include?(::Date.new(2015, 12, 24))).to eq(false)
          expect(subject.include?(::Date.new(2015, 1, 23))).to eq(false)
        end
      end
    end
  end
end
