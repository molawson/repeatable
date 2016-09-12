require 'spec_helper'

module Repeatable
  module Expression
    describe EndsAfter do
      let(:inner_expression) { Repeatable::Expression::Weekday.new(weekday: 1) }
      subject { described_class.new(count: 3, from: ::Date.new(2014, 1, 1), expression: inner_expression) }

      it_behaves_like 'an expression'

      describe '#include?' do
        it 'returns true for dates less than ends_after' do
          expect(subject).to include(::Date.new(2014, 1, 6))
          expect(subject).to include(::Date.new(2014, 1, 13))
          expect(subject).to include(::Date.new(2014, 1, 20))
        end

        it 'returns false for dates greater than the ends_at' do
          expect(subject).not_to include(::Date.new(2014, 1, 27))
        end

        it 'returns false for dates before the from' do
          expect(subject).not_to include(::Date.new(2013, 12, 30))
        end
      end

      describe '#to_h' do
        it 'returns a hash with the class name and arguments' do
          expected_hash = {
            ends_after: {
              count: 3,
              from: "2014-01-01",
              expression: { weekday: { weekday: 1 } }
            }
          }

          expect(subject.to_h).to eq(expected_hash)
        end
      end

      describe '#==' do
        it 'returns true if the expressions and ends-at match' do
          equal_expression = described_class.new(
            count: 3,
            from: ::Date.new(2014, 1, 1),
            expression: inner_expression,
          )
          expect(subject).to eq(equal_expression)
        end

        it 'returns false if the expressions do not match' do
          unequal_expression = described_class.new(
            count: 3,
            from: ::Date.new(2014, 1, 1),
            expression: Repeatable::Expression::DayInMonth.new(day: 5),
          )

          expect(subject).not_to eq(unequal_expression)
        end

        it 'returns false if froms do not match' do
          unequal_expression = described_class.new(
            count: 3,
            from: ::Date.new(2014, 10, 10),
            expression: inner_expression,
          )
          expect(subject).not_to eq(unequal_expression)
        end

        it 'returns false counts do not match' do
          unequal_expression = described_class.new(
            count: 6,
            from: ::Date.new(2014, 1, 1),
            expression: inner_expression,
          )
          expect(subject).not_to eq(unequal_expression)
        end
      end

      describe '#hash' do
        it 'of two expressions with the same arguments are the same' do
          other_ends_after = described_class.new(
            count: 3,
            from: ::Date.new(2014, 1, 1),
            expression: inner_expression,
          )
          expect(subject.hash).to eq(other_ends_after.hash)
        end

        it 'of two expressions with different froms' do
          other_ends_after = described_class.new(
            count: 3,
            from: ::Date.new(2014, 10, 10),
            expression: inner_expression,
          )
          expect(subject.hash).not_to eq(other_ends_after.hash)
        end

        it 'of two expressions with different counts' do
          other_ends_after = described_class.new(
            count: 6,
            from: ::Date.new(2014, 1, 1),
            expression: inner_expression,
          )
          expect(subject.hash).not_to eq(other_ends_after.hash)
        end

        it 'of two expressions with different expressions' do
          other_ends_after = described_class.new(
            count: 3,
            from: ::Date.new(2014, 1, 1),
            expression: Repeatable::Expression::ExactDate.new(date: ::Date.new(2014, 9, 1))
          )
          expect(subject.hash).not_to eq(other_ends_after.hash)
        end
      end

      describe 'parsing' do
        it 'works with the Repeatable::Parser', :focus do
          restored_from_hash = Repeatable::Parser.call({
            ends_after: {
              from: "2014-01-01",
              count: 3,
              expression: { weekday: { weekday: 1 } }
            }
          })

          p subject
          p restored_from_hash
          expect(subject).to eq(restored_from_hash)
        end
      end
    end
  end
end
