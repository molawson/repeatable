require 'spec_helper'

module Repeatable
  describe Schedule do
    include ScheduleArguments

    subject { described_class.new(arg) }

    describe '#initialize' do
      context 'with a Hash' do
        let(:arg) { simple_range_hash }

        it 'does not blow up' do
          expect { subject }.not_to raise_error
        end
      end

      context 'with an Expression object' do
        let(:arg) { Repeatable::Expression::RangeInYear.new(start_month: 10, end_month: 12) }

        it 'does not blow up' do
          expect { subject }.not_to raise_error
        end
      end

      context 'with something else' do
        let(:arg) { 'a random string' }

        it 'raises a ArgumentError' do
          expect { subject }.to raise_error(ParseError, "Can't build a Repeatable::Schedule from String")
        end
      end
    end

    describe '#occurrences' do
      let(:arg) { simple_range_hash }

      context 'with convertible non-Date arguments' do
        expected_results = [
          Date.new(2015, 11, 30),
          Date.new(2015, 12, 1),
          Date.new(2015, 12, 2),
        ]
        argument_pairs = [
          ['2015-11-30', '2015-12-2'],
          [DateTime.new(2015, 11, 30), DateTime.new(2015, 12, 2)],
        ]

        argument_pairs.each do |args|
          it "can handle #{args.first.class} arguments" do
            expect(subject.occurrences(*args)).to eq(expected_results)
          end
        end
      end

      context 'with non convertible arguments' do
        it 'raises an exception' do
          expect { subject.occurrences('asdf', 'xyz') }.to raise_error(TypeError)
        end
      end

      context 'simple range expression' do
        it 'returns all matching dates within the range given' do
          expect(
            subject.occurrences(Date.new(2015, 11, 28), Date.new(2015, 12, 3))
          ).to eq(
            [
              Date.new(2015, 11, 28),
              Date.new(2015, 11, 29),
              Date.new(2015, 11, 30),
              Date.new(2015, 12, 1),
              Date.new(2015, 12, 2),
              Date.new(2015, 12, 3),
            ]
          )
        end

        it 'allows the dates being the same' do
          expect(
            subject.occurrences(Date.new(2015, 11, 28), Date.new(2015, 11, 28))
          ).to eq(
            [ Date.new(2015, 11, 28) ]
          )
        end

        it 'raises an ArgumentError if end_date is before start_date' do
          expect{
            subject.occurrences(Date.new(2015, 11, 28), Date.new(2015, 11, 27))
          }.to raise_error(ArgumentError)
        end

      end

      context 'set expression' do
        let(:arg) { set_expression_hash }

        it 'returns all matching dates within the range given' do
          expect(
            subject.occurrences(Date.new(2015, 8, 1), Date.new(2015, 10, 3))
          ).to eq(
            [
              Date.new(2015, 8, 23),
              Date.new(2015, 9, 23),
              Date.new(2015, 10, 1),
              Date.new(2015, 10, 2),
              Date.new(2015, 10, 3),
            ]
          )
        end
      end

      context 'nested set expression' do
        let(:arg) { nested_set_expression_hash }

        it 'returns all matching dates within the range given' do
          expect(
            subject.occurrences(Date.new(2015, 10, 30), Date.new(2016, 1, 30))
          ).to eq(
            [
              Date.new(2015, 11, 23),
              Date.new(2015, 11, 24),
              Date.new(2015, 12, 23),
              Date.new(2015, 12, 24),
            ]
          )
        end

        context 'set expression given as already composed objects' do
          let(:arg) { nested_set_expression_object }

          it 'returns all matching dates within the range given' do
            expect(
              subject.occurrences(Date.new(2015, 10, 30), Date.new(2016, 1, 30))
            ).to eq(
              [
                Date.new(2015, 11, 23),
                Date.new(2015, 11, 24),
                Date.new(2015, 12, 23),
                Date.new(2015, 12, 24),
              ]
            )
          end
        end
      end
    end

    describe '#next_occurrence' do
      let(:arg) { simple_range_hash }

      context 'with convertible non-Date argument' do
        expected_result = Date.new(2015, 10, 1)
        arguments = ['2015-1-1', DateTime.new(2015, 1, 1)]

        arguments.each do |arg|
          it "can handle #{arg.class} argument" do
            expect(subject.next_occurrence(arg)).to eq(expected_result)
          end
        end
      end

      context 'with non convertible argument' do
        it 'raises an exception' do
          expect { subject.next_occurrence('asdf') }.to raise_error(TypeError)
        end
      end

      context 'simple range expression' do
        it 'returns the next occurrence matching the range' do
          expect(subject.next_occurrence(Date.new(2015, 1, 1))).to eq(Date.new(2015, 10, 1))
        end
      end

      context 'set expression' do
        let(:arg) { set_expression_hash }

        it 'returns the next occurrence that matches the full expression' do
          expect(subject.next_occurrence(Date.new(2015, 9, 2))).to eq(Date.new(2015, 9, 23))
        end
      end

      context 'nested set expression' do
        let(:arg) { nested_set_expression_hash }

        it 'returns the next occurrence that matches the full expression' do
          expect(subject.next_occurrence(Date.new(2015, 9, 2))).to eq(Date.new(2015, 10, 23))
        end
      end

      context 'include_start option' do
        # Intentionally all-inclusive range to make testing this option easier
        let(:arg) { { range_in_year: { start_month: 1, end_month: 12 } } }
        let(:start_date) { Date.new(2015, 11, 1) }

        context 'excluding start date (default)' do
          it 'will not return the start date even if it is part of the schedule' do
            expect(subject.next_occurrence(start_date))
              .to eq(Date.new(2015, 11, 2))
            expect(subject.next_occurrence(start_date, include_start: false))
              .to eq(Date.new(2015, 11, 2))
          end
        end

        context 'including start date' do
          it 'will return the start date if it is part of the schedule' do
            expect(subject.next_occurrence(start_date, include_start: true))
              .to eq(Date.new(2015, 11, 1))
          end

          it 'include_start can be specified without an explicit start_date' do
            expect(subject.next_occurrence(include_start: true))
              .to eq(Date.today)
          end
        end
      end

      context 'limit option' do
        let(:arg) do
          # Leap day
          {
            intersection: [
              { day_in_month: { day: 29 } },
              { range_in_year: { start_month: 2 } }
            ]
          }
        end
        let(:start_date) { Date.new(2012, 3, 1) }

        it 'default limit is far enough away as to not interfere with infrequent events' do
          expect(subject.next_occurrence(start_date)).to eq(Date.new(2016, 2, 29))
        end

        it 'returns nil if the limit is reached before an occurrence is found' do
          expect(subject.next_occurrence(start_date, limit: 365.25*3)).to be_nil
        end
      end
    end

    describe '#occuring?' do
      let(:arg) { simple_range_hash }

      context 'with convertible non-Date argument' do
        arguments = ['2015-10-1', DateTime.new(2015, 10, 1)]

        arguments.each do |arg|
          it "can handle #{arg.class} argument" do
            expect(subject.include?(arg)).to eq(true)
          end
        end
      end

      context 'with non convertible argument' do
        it 'raises an exception' do
          expect { subject.include?('asdf') }.to raise_error(TypeError)
        end
      end

      context 'simple range expression' do
        it 'returns true for dates within the range' do
          expect(subject.include?(Date.new(2015, 10, 1))).to eq(true)
          expect(subject.include?(Date.new(2015, 11, 15))).to eq(true)
          expect(subject.include?(Date.new(2015, 12, 31))).to eq(true)
        end

        it 'returns false for dates outside of the range' do
          expect(subject.include?(Date.new(2015, 9, 30))).to eq(false)
          expect(subject.include?(Date.new(2015, 2, 23))).to eq(false)
        end
      end

      context 'set expression' do
        let(:arg) { set_expression_hash }

        it 'returns true for dates that match the full expression' do
          expect(subject.include?(Date.new(2015, 9, 23))).to eq(true)
          expect(subject.include?(Date.new(2015, 10, 2))).to eq(true)
          expect(subject.include?(Date.new(2015, 10, 23))).to eq(true)
          expect(subject.include?(Date.new(2015, 11, 3))).to eq(true)
          expect(subject.include?(Date.new(2015, 11, 23))).to eq(true)
          expect(subject.include?(Date.new(2015, 12, 23))).to eq(true)
          expect(subject.include?(Date.new(2015, 12, 24))).to eq(true)
          expect(subject.include?(Date.new(2015, 1, 23))).to eq(true)
        end

        it 'returns true for dates that do not match the full expression' do
          expect(subject.include?(Date.new(2015, 9, 2))).to eq(false)
          expect(subject.include?(Date.new(2015, 1, 2))).to eq(false)
        end
      end

      context 'nested set expression' do
        let(:arg) { nested_set_expression_hash }

        it 'returns true for dates that match the full expression' do
          expect(subject.include?(Date.new(2015, 10, 23))).to eq(true)
          expect(subject.include?(Date.new(2015, 11, 23))).to eq(true)
          expect(subject.include?(Date.new(2015, 12, 23))).to eq(true)
          expect(subject.include?(Date.new(2015, 12, 24))).to eq(true)
        end

        it 'returns true for dates that do not match the full expression' do
          expect(subject.include?(Date.new(2015, 9, 23))).to eq(false)
          expect(subject.include?(Date.new(2015, 10, 2))).to eq(false)
          expect(subject.include?(Date.new(2015, 12, 25))).to eq(false)
          expect(subject.include?(Date.new(2015, 1, 23))).to eq(false)
        end
      end
    end

    describe '#to_h' do
      context 'initialized with a hash' do
        let(:arg) { nested_set_expression_hash }

        it 'returns the same hash' do
          expect(subject.to_h).to eq(arg)
        end
      end

      context 'initialized with an Expression object' do
        let(:arg) { nested_set_expression_object }

        it 'returns the hash representation of that Expression' do
          expect(subject.to_h).to eq(nested_set_expression_hash)
        end
      end
    end
  end
end
