require 'spec_helper'

module Repeatable
  module Expression
    describe Base do
      describe '.===' do
        context 'other is a class' do
          it 'returns true when described_class is an ancestor of the given class' do
            expect(described_class === Repeatable::Expression::Set).to eq(true)
          end

          it 'returns false when described_class is not an ancestor of the given class' do
            expect(described_class === Repeatable::Schedule).to eq(false)
          end
        end

        context 'other is an instance of a class' do
          it 'uses default ==== (is_a?) behavior' do
            expect(described_class === Repeatable::Expression::Set.new).to eq(true)
            expect(described_class === '').to eq(false)
          end
        end
      end

      describe '#include?' do
        it 'raises a NotImplemented Error' do
          expect { subject.include?('anything') }.to raise_error(NotImplementedError)
        end
      end

      describe '#to_h' do
        it 'raises a NotImplemented Error' do
          expect { subject.to_h }.to raise_error(NotImplementedError)
        end
      end

      describe 'set operators' do
        describe '+' do
          let(:fridays) { Weekday.new(weekday: 5) }
          let(:saturdays) { Weekday.new(weekday: 6) }
          let(:sundays) { Weekday.new(weekday: 0) }
          let(:weekends) { Union.new(saturdays, sundays) }
          let(:summer_weekends) { Union.new(fridays, saturdays, sundays) }

          it 'returns a Union of the two expressions' do
            expect(saturdays + sundays).to eq(weekends)
          end

          it 'returns a Union without redundant nesting when receiver is a Union' do
            expect(weekends + fridays).to eq(summer_weekends)
          end

          it 'returns a Union without redundant nesting when argument is a Union' do
            expect(fridays + weekends).to eq(summer_weekends)
          end

          it 'returns a Union without redundant nesting when both are Unions' do
            expect(weekends + summer_weekends).to eq(summer_weekends)
          end
        end

        describe '|' do
          let(:mondays) { Weekday.new(weekday: 1) }
          let(:fourths) { DayInMonth.new(day: 4) }
          let(:july) { RangeInYear.new(start_month: 7) }
          let(:fourth_of_july) { Intersection.new(july, fourths) }
          let(:three_day_wekeend) { Intersection.new(mondays, fourths, july) }

          it 'returns an Intersection of the two expressions' do
            expect(fourths | july).to eq(fourth_of_july)
          end

          it 'returns an Intersection without redundant nesting when receiver is a Intersection' do
            expect(fourth_of_july | mondays).to eq(three_day_wekeend)
          end

          it 'returns an Intersection without redundant nesting when argument is a Intersection' do
            expect(mondays | fourth_of_july).to eq(three_day_wekeend)
          end

          it 'returns a Intersection without redundant nesting when both are Intersections' do
            expect(three_day_wekeend | fourth_of_july).to eq(three_day_wekeend)
          end
        end

        describe '-' do
          let(:mondays) { Weekday.new(weekday: 1) }
          let(:tuesdays) { Weekday.new(weekday: 2) }
          let(:wednesdays) { Weekday.new(weekday: 3) }
          let(:thursdays) { Weekday.new(weekday: 4) }
          let(:fridays) { Weekday.new(weekday: 5) }
          let(:workdays) { Union.new(mondays, tuesdays, wednesdays, thursdays, fridays) }
          let(:summer_workdays) { Difference.new(included: workdays, excluded: fridays) }
          let(:three_day_work_week) {
            Difference.new(included: workdays, excluded: Union.new(thursdays, fridays))
          }

          it 'returns a Difference of the two expressions' do
            expect(workdays - fridays).to eq(summer_workdays)
          end

          it 'returns a Difference without redundant nesting when receiver is a Difference' do
            expect(summer_workdays - thursdays).to eq(three_day_work_week)
          end

          it 'returns a Difference with no special transformations when argument is a Difference' do
            expected = Difference.new(included: thursdays, excluded: summer_workdays)
            expect(thursdays - summer_workdays).to eq(expected)
          end

          it 'returns a Difference with only receiver redundancy removed with two Differences' do
            expected = Difference.new(
              included: workdays,
              excluded: Union.new(summer_workdays, thursdays, fridays),
            )
            expect(three_day_work_week - summer_workdays).to eq(expected)
          end
        end
      end
    end
  end
end
