require 'spec_helper'

module Repeatable
  module Expression
    describe EndsAt do
      let(:inner_expression) { Repeatable::Expression::DayInMonth.new(day: 23) }
      let(:subject) { described_class.new(ends_at: ::Date.new(2015, 9, 1), expression: inner_expression) }

      it_behaves_like 'an expression'

      describe '#include?' do
        it 'returns true for dates less than the ends-at' do
          expect(subject).to include(::Date.new(2015, 1, 23))
        end

        it 'returns false for dates greater than the ends_at' do
          expect(subject).not_to include(::Date.new(2015, 9, 23))
        end
      end

      describe '#to_h' do
        it 'returns a hash with the class name and arguments' do
          expected_hash = {
            ends_at: {
              ends_at: "2015-09-01",
              expression: { day_in_month: { day: 23 } }
            }
          }

          expect(subject.to_h).to eq(expected_hash)
        end
      end

      describe '#==' do
        it 'returns true if the expressions and ends-at match' do
          equal_ends_at = described_class.new(ends_at: ::Date.new(2015, 9, 1), expression: inner_expression)
          expect(subject).to eq(equal_ends_at)
        end

        it 'returns false if the expressions do not match' do
          unequal_ends_at = described_class.new(
            ends_at: ::Date.new(2015, 9, 1),
            expression: Repeatable::Expression::DayInMonth.new(day: 5),
          )

          expect(subject).not_to eq(unequal_ends_at)
        end

        it 'returns false ends-ats do not match' do
          unequal_ends_at = described_class.new(
            ends_at: ::Date.new(2015, 9, 2),
            expression: inner_expression,
          )
          expect(subject).not_to eq(unequal_ends_at)
        end
      end

      describe '#hash' do
        it 'of two expressions with the same arguments are the same' do
          other_ends_at = described_class.new(ends_at: ::Date.new(2015, 9, 1), expression: inner_expression)
          expect(subject.hash).to eq(other_ends_at.hash)
        end

        it 'of two expressions with different ends_ats' do
          other_ends_at = described_class.new(ends_at: ::Date.new(2015, 10, 1), expression: inner_expression)
          expect(subject.hash).not_to eq(other_ends_at.hash)
        end

        it 'of two expressions with different expressions' do
          other_ends_at = described_class.new(
            ends_at: ::Date.new(2015, 9, 1),
            expression: Repeatable::Expression::ExactDate.new(date: ::Date.new(2014, 9, 1))
          )
          expect(subject.hash).not_to eq(other_ends_at.hash)
        end
      end

      describe 'parsing' do
        it 'works with the Repeatable::Parser' do
          restored_from_hash = Repeatable::Parser.call({
            ends_at: {
              ends_at: "2015-09-01",
              expression: { day_in_month: { day: 23 } }
            }
          })

          expect(subject).to eq(restored_from_hash)
        end
      end
    end
  end
end
