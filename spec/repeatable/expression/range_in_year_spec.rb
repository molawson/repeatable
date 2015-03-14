require 'spec_helper'

module Repeatable
  module Expression
    describe RangeInYear do
      let(:args) { { start_month: 10 } }

      subject { described_class.new(args) }

      it_behaves_like 'an expression'

      describe '#include?' do
        context 'only start_month given' do
          it 'return true when the date falls in month given' do
            expect(subject).to include(::Date.new(2015, 10, 5))
          end

          it 'return false when the date falls outside of month given' do
            expect(subject).not_to include(::Date.new(2015, 11, 1))
          end
        end

        context 'only start_month and end_month given' do
          let(:args) { { start_month: 8, end_month: 10 } }

          it 'return true when the date falls in the months given' do
            expect(subject).to include(::Date.new(2015, 8, 1))
            expect(subject).to include(::Date.new(2015, 9, 15))
            expect(subject).to include(::Date.new(2015, 10, 1))
            expect(subject).to include(::Date.new(2015, 10, 31))
          end

          it 'return false when the date falls outside of the months given' do
            expect(subject).not_to include(::Date.new(2015, 7, 31))
            expect(subject).not_to include(::Date.new(2015, 11, 1))
          end
        end

        context 'only start_month, end_month, and start_day given' do
          let(:args) { { start_month: 8, end_month: 10, start_day: 20 } }

          it 'returns true when the date falls anywhere in the end_month' do
            expect(subject).to include(::Date.new(2015, 10, 1))
            expect(subject).to include(::Date.new(2015, 10, 31))
          end

          it 'return true when the date falls on or after the start_day in the start_month' do
            expect(subject).to include(::Date.new(2015, 8, 20))
            expect(subject).to include(::Date.new(2015, 8, 31))
          end

          it 'return true when the date falls on any day in a month between the start_month and end_month' do
            expect(subject).to include(::Date.new(2015, 9, 1))
            expect(subject).to include(::Date.new(2015, 9, 30))
          end

          it 'return false when the date falls before the start_day in the start_month' do
            expect(subject).not_to include(::Date.new(2015, 8, 19))
          end

          it 'return false when the date falls outside of the months given' do
            expect(subject).not_to include(::Date.new(2015, 7, 31))
            expect(subject).not_to include(::Date.new(2015, 11, 1))
          end
        end

        context 'only start_month, end_month, and end_day given' do
          let(:args) { { start_month: 8, end_month: 10, end_day: 10 } }

          it 'returns true when the date falls anywhere in the start_month' do
            expect(subject).to include(::Date.new(2015, 8, 1))
            expect(subject).to include(::Date.new(2015, 8, 31))
          end

          it 'return true when the date falls on or before the end_day in the end_month' do
            expect(subject).to include(::Date.new(2015, 10, 1))
            expect(subject).to include(::Date.new(2015, 10, 10))
          end

          it 'return true when the date falls on any day in a month between the start_month and end_month' do
            expect(subject).to include(::Date.new(2015, 9, 1))
            expect(subject).to include(::Date.new(2015, 9, 30))
          end

          it 'return false when the date falls after the end_day in the end_month' do
            expect(subject).not_to include(::Date.new(2015, 10, 11))
          end

          it 'return false when the date falls outside of the months given' do
            expect(subject).not_to include(::Date.new(2015, 7, 31))
            expect(subject).not_to include(::Date.new(2015, 11, 1))
          end
        end

        context 'start_month, end_month, start_day, and end_day given' do
          let(:args) { { start_month: 8, end_month: 10, start_day: 20, end_day: 10 } }

          it 'return true when the date falls on or after the start_day in the start_month' do
            expect(subject).to include(::Date.new(2015, 8, 20))
            expect(subject).to include(::Date.new(2015, 8, 31))
          end

          it 'return true when the date falls on or before the end_day in the end_month' do
            expect(subject).to include(::Date.new(2015, 10, 1))
            expect(subject).to include(::Date.new(2015, 10, 10))
          end

          it 'return true when the date falls on any day in a month between the start_month and end_month' do
            expect(subject).to include(::Date.new(2015, 9, 1))
            expect(subject).to include(::Date.new(2015, 9, 30))
          end

          it 'return false when the date falls before the start_day in the start_month' do
            expect(subject).not_to include(::Date.new(2015, 8, 19))
          end

          it 'return false when the date falls after the end_day in the end_month' do
            expect(subject).not_to include(::Date.new(2015, 10, 11))
          end

          it 'return false when the date falls outside of the months given' do
            expect(subject).not_to include(::Date.new(2015, 7, 31))
            expect(subject).not_to include(::Date.new(2015, 11, 1))
          end
        end
      end

      describe '#to_h' do
        context 'with the minimum args' do
          it 'returns a hash with the class name and only given arguments' do
            expect(subject.to_h).to eq(range_in_year: args)
          end
        end

        context 'with mixed args' do
          let(:args) { { start_month: 8, end_month: 10, start_day: 20 } }

          it 'returns a hash with the class name and only given arguments' do
            expect(subject.to_h).to eq(range_in_year: args)
          end
        end

        context 'with all args' do
          let(:args) { { start_month: 8, end_month: 10, start_day: 20, end_day: 10 } }

          it 'returns a hash with the class name and only given arguments' do
            expect(subject.to_h).to eq(range_in_year: args)
          end
        end
      end

      describe '#==' do
        it 'returns true if the expressions have the same arguments' do
          expect(described_class.new(start_month: 1, end_month: 2, start_day: 3, end_day: 4))
            .to eq(described_class.new(start_month: 1, end_month: 2, start_day: 3, end_day: 4))
        end

        it 'returns true if the expressions have the same arguments (accounting for defaults)' do
          expect(described_class.new(start_month: 1, end_month: 1, start_day: 0, end_day: 0))
            .to eq(described_class.new(start_month: 1))
        end

        it 'returns false if the expressions have one differing argument' do
          expect(described_class.new(start_month: 1, end_month: 2, start_day: 3, end_day: 4))
            .not_to eq(described_class.new(start_month: 1, end_month: 2, start_day: 3, end_day: 5))
        end

        it 'returns false if the given expression is not a RangeInYear' do
          expect(described_class.new(start_month: 1, end_month: 2, start_day: 3, end_day: 4))
            .not_to eq(DayInMonth.new(day: 1))
        end
      end

      describe '#hash' do
        let(:expression) do
          described_class.new(start_month: 1, end_month: 2, start_day: 3, end_day: 4)
        end

        it 'of two expressions with the same arguments are the same' do
          other_expression = described_class.new(start_month: 1, end_month: 2, start_day: 3, end_day: 4)
          expect(expression.hash).to eq(other_expression.hash)
        end

        it 'of two expressions with the same arguments (accounting for defaults) are the same' do
          expression = described_class.new(start_month: 1, end_month: 1, start_day: 0, end_day: 0)
          other_expression = described_class.new(start_month: 1)
          expect(expression.hash).to eq(other_expression.hash)
        end

        it 'of two expressions with one differing argument are not the same' do
          other_expression = described_class.new(start_month: 1, end_month: 2, start_day: 3, end_day: 5)
          expect(expression.hash).not_to eq(other_expression.hash)
        end

        it 'of two expressions of different types are not the same' do
          other_expression = DayInMonth.new(day: 1)
          expect(expression.hash).not_to eq(other_expression.hash)
        end
      end
    end
  end
end
