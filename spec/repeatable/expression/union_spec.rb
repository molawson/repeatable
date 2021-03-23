require 'spec_helper'

module Repeatable
  module Expression
    describe Union do
      let(:twenty_third) { Repeatable::Expression::DayInMonth.new(day: 23) }
      let(:oct_thru_dec) { Repeatable::Expression::RangeInYear.new(start_month: 10, end_month: 12) }

      it_behaves_like 'an expression'

      describe '#initialize' do
        context 'when there are no Union elements' do
          subject { described_class.new(twenty_third) }

          it 'returns all elements as is' do
            expected_hash = { union: [{ day_in_month: { day: 23 } }] }
            expect(subject.to_h).to eq(expected_hash)
          end
        end

        context 'when there are Union elements' do
          subject { described_class.new(twenty_third).union(oct_thru_dec) }

          specify do
            expected_hash = {
              union: [
                { day_in_month: { day: 23 } },
                { range_in_year: { start_month: 10, end_month: 12 } }
              ]
            }
            expect(subject.to_h).to eq(expected_hash)
          end
        end
      end

      describe '#include?' do
        subject { described_class.new(twenty_third, oct_thru_dec) }

        it 'returns true for dates that match any expression' do
          expect(subject.include?(::Date.new(2015, 9, 2))).to eq(false)
          expect(subject.include?(::Date.new(2015, 9, 23))).to eq(true)
          expect(subject.include?(::Date.new(2015, 10, 2))).to eq(true)
          expect(subject.include?(::Date.new(2015, 10, 23))).to eq(true)
          expect(subject.include?(::Date.new(2015, 11, 3))).to eq(true)
          expect(subject.include?(::Date.new(2015, 11, 23))).to eq(true)
          expect(subject.include?(::Date.new(2015, 12, 23))).to eq(true)
          expect(subject.include?(::Date.new(2015, 12, 24))).to eq(true)
          expect(subject.include?(::Date.new(2015, 1, 23))).to eq(true)
          expect(subject.include?(::Date.new(2015, 1, 2))).to eq(false)
        end
      end
    end
  end
end
