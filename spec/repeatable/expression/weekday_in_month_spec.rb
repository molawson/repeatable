require 'spec_helper'

module Repeatable
  module Expression
    describe WeekdayInMonth do
      subject { described_class.new(weekday: 0, count: 1) }

      it_behaves_like 'an expression'

      describe '#include?' do
        context 'weekday matches' do
          it 'returns true for dates matching the week given' do
            expect(subject).to include(::Date.new(2015, 1, 4))
          end

          it 'returns false for dates not matching the week given' do
            expect(subject).not_to include(::Date.new(2015, 1, 11))
          end
        end

        context 'weekday does not match' do
          it 'returns false for dates matching the week given' do
            expect(subject).not_to include(::Date.new(2015, 1, 1))
          end

          it 'returns false for dates not matching the week given' do
            expect(subject).not_to include(::Date.new(2015, 1, 12))
          end
        end
      end

      describe '#to_h' do
        it 'returns a hash with the class name and arguments' do
          expect(subject.to_h).to eq(weekday_in_month: { weekday: 0, count: 1 })
        end
      end

      describe '#==' do
        it 'returns true if the expressions have the same arguments' do
          expect(described_class.new(weekday: 1, count: 2))
            .to eq(described_class.new(weekday: 1, count: 2))
        end

        it 'returns false if the expressions have one differing argument' do
          expect(described_class.new(weekday: 1, count: 2))
            .not_to eq(described_class.new(weekday: 1, count: 3))
        end

        it 'returns false if the given expression is not a WeekdayInMonth' do
          expect(described_class.new(weekday: 1, count: 2))
            .not_to eq(DayInMonth.new(day: 1))
        end
      end
    end
  end
end
