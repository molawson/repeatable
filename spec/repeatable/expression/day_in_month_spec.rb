require 'spec_helper'

module Repeatable
  module Expression
    describe DayInMonth do
      subject { described_class.new(day: 21) }

      it_behaves_like 'an expression'

      describe '#include?' do
        it 'returns true for dates matching the day given' do
          expect(subject).to include(::Date.new(2015, 1, 21))
        end

        it 'returns false for dates not matching the day given' do
          expect(subject).not_to include(::Date.new(2015, 1, 22))
        end
      end

      describe '#to_h' do
        it 'returns a hash with the class name and arguments' do
          expect(subject.to_h).to eq(day_in_month: { day: 21 })
        end
      end

      describe '#==' do
        it 'returns true if the expressions have the same argument' do
          expect(described_class.new(day: 21)).to eq(described_class.new(day: 21))
        end

        it 'returns false if the expressions do not have the same argument' do
          expect(described_class.new(day: 21)).not_to eq(described_class.new(day: 22))
        end

        it 'returns false if the given expression is not a DayInMonth' do
          expect(described_class.new(day: 21)).not_to eq(Weekday.new(weekday: 2))
        end
      end

      describe '#eql?' do
        let(:expression) { described_class.new(day: 21) }

        it 'returns true if the expressions have the same argument' do
          other_expression = described_class.new(day: 21)
          expect(expression).to eql(other_expression)
        end

        it 'returns false if the expressions do not have the same argument' do
          other_expression = described_class.new(day: 22)
          expect(expression).not_to eql(other_expression)
        end

        it 'returns false if the given expression is not a DayInMonth' do
          other_expression = Weekday.new(weekday: 2)
          expect(expression).not_to eql(other_expression)
        end
      end

      describe '#hash' do
        let(:expression) { described_class.new(day: 21) }

        it 'of two expressions with the same arguments are the same' do
          other_expression = described_class.new(day: 21)
          expect(expression.hash).to eq(other_expression.hash)
        end

        it 'of two expressions with different arguments are not the same' do
          other_expression = described_class.new(day: 22)
          expect(expression.hash).not_to eq(other_expression.hash)
        end

        it 'of two expressions of different types are not the same' do
          other_expression = Weekday.new(weekday: 2)
          expect(expression.hash).not_to eq(other_expression.hash)
        end
      end

      describe 'negative numbers' do
        context 'last' do
          let(:expression) { described_class.new(day: -1) }

          it 'correctly identified the last day of a 31 day month' do
            expect(expression).to include(::Date.new(2015, 1, 31))
          end

          it 'correctly identified the last day of a 28 day month' do
            expect(expression).to include(::Date.new(2015, 2, 28))
          end
        end

        context '3rd to last' do
          let(:expression) { described_class.new(day: -3) }

          it 'correctly identified the 3rd to last day of a 31 day month' do
            expect(expression).to include(::Date.new(2015, 1, 29))
          end

          it 'correctly identified the 3rd to last day of a 28 day month' do
            expect(expression).to include(::Date.new(2015, 2, 26))
          end
        end
      end
    end
  end
end
