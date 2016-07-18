require 'spec_helper'

module Repeatable
  module Expression
    describe ExactDate do
      subject { described_class.new(date: ::Date.new(2016, 8, 25)) }

      it_behaves_like 'an expression'

      describe '#include?' do
        it 'returns true for the exact date' do
          expect(subject).to include(::Date.new(2016, 8, 25))
        end

        it 'returns false for dates not matching the day given' do
          expect(subject).not_to include(::Date.new(2015, 8, 25))
          expect(subject).not_to include(::Date.new(2016, 8, 24))
          expect(subject).not_to include(::Date.new(2016, 8, 26))
          expect(subject).not_to include(::Date.new(2017, 8, 25))
        end
      end

      describe '#to_h' do
        it 'returns a hash with the class name and arguments' do
          expect(subject.to_h).to eq(exact_date: { date: "2016-08-25" })
        end
      end

      describe '#==' do
        it 'returns true if the expressions have the same argument' do
          other_expression = described_class.new(date: ::Date.new(2016, 8, 25))
          expect(subject).to eq(other_expression)
        end

        it 'returns true if the expression was initialized from a string' do
          other_expression = described_class.new(date: '2016-08-25')
          expect(subject).to eq(other_expression)
        end

        it 'returns false if the expressions do not have the same argument' do
          other_expression = described_class.new(date: ::Date.new(2016, 8, 26))
          expect(subject).not_to eq(other_expression)
        end

        it 'returns false if the given expression is not a ExactDate' do
          expect(subject).not_to eq(Weekday.new(weekday: 2))
        end
      end

      describe '#eql?' do
        it 'returns true if the expressions have the same argument' do
          other_expression = described_class.new(date: ::Date.new(2016, 8, 25))
          expect(subject).to eql(other_expression)
        end

        it 'returns false if the expressions do not have the same argument' do
          other_expression = described_class.new(date: ::Date.new(2016, 8, 26))
          expect(subject).not_to eql(other_expression)
        end

        it 'returns false if the given expression is not a DayInMonth' do
          other_expression = Weekday.new(weekday: 2)
          expect(subject).not_to eql(other_expression)
        end
      end

      describe '#hash' do
        it 'of two expressions with the same arguments are the same' do
          other_expression = described_class.new(date: ::Date.new(2016, 8, 25))
          expect(subject.hash).to eq(other_expression.hash)
        end

        it 'of two expressions with different arguments are not the same' do
          other_expression = described_class.new(date: ::Date.new(2016, 8, 26))
          expect(subject.hash).not_to eq(other_expression.hash)
        end

        it 'of two expressions of different types are not the same' do
          other_expression = Weekday.new(weekday: 2)
          expect(subject.hash).not_to eq(other_expression.hash)
        end
      end

      describe 'parsing' do
        it 'works with the Repeatable::Parser' do
          restored_from_hash = Repeatable::Parser.call(subject.to_h)
          expect(subject).to eq(restored_from_hash)
        end
      end
    end
  end
end
