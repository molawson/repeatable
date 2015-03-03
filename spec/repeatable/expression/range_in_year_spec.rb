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
            expect(subject).to include(Date.new(2015, 10, 5))
          end

          it 'return false when the date falls outside of month given' do
            expect(subject).not_to include(Date.new(2015, 11, 1))
          end
        end

        context 'only start_month and end_month given' do
          let(:args) { { start_month: 8, end_month: 10 } }

          it 'return true when the date falls in the months given' do
            expect(subject).to include(Date.new(2015, 8, 1))
            expect(subject).to include(Date.new(2015, 9, 15))
            expect(subject).to include(Date.new(2015, 10, 1))
            expect(subject).to include(Date.new(2015, 10, 31))
          end

          it 'return false when the date falls outside of the months given' do
            expect(subject).not_to include(Date.new(2015, 7, 31))
            expect(subject).not_to include(Date.new(2015, 11, 1))
          end
        end

        context 'only start_month, end_month, and start_day given' do
          let(:args) { { start_month: 8, end_month: 10, start_day: 20 } }

          it 'returns true when the date falls anywhere in the end_month' do
            expect(subject).to include(Date.new(2015, 10, 1))
            expect(subject).to include(Date.new(2015, 10, 31))
          end

          it 'return true when the date falls on or after the start_day in the start_month' do
            expect(subject).to include(Date.new(2015, 8, 20))
            expect(subject).to include(Date.new(2015, 8, 31))
          end

          it 'return true when the date falls on any day in a month between the start_month and end_month' do
            expect(subject).to include(Date.new(2015, 9, 1))
            expect(subject).to include(Date.new(2015, 9, 30))
          end

          it 'return false when the date falls before the start_day in the start_month' do
            expect(subject).not_to include(Date.new(2015, 8, 19))
          end

          it 'return false when the date falls outside of the months given' do
            expect(subject).not_to include(Date.new(2015, 7, 31))
            expect(subject).not_to include(Date.new(2015, 11, 1))
          end
        end

        context 'only start_month, end_month, and end_day given' do
          let(:args) { { start_month: 8, end_month: 10, end_day: 10 } }

          it 'returns true when the date falls anywhere in the start_month' do
            expect(subject).to include(Date.new(2015, 8, 1))
            expect(subject).to include(Date.new(2015, 8, 31))
          end

          it 'return true when the date falls on or before the end_day in the end_month' do
            expect(subject).to include(Date.new(2015, 10, 1))
            expect(subject).to include(Date.new(2015, 10, 10))
          end

          it 'return true when the date falls on any day in a month between the start_month and end_month' do
            expect(subject).to include(Date.new(2015, 9, 1))
            expect(subject).to include(Date.new(2015, 9, 30))
          end

          it 'return false when the date falls after the end_day in the end_month' do
            expect(subject).not_to include(Date.new(2015, 10, 11))
          end

          it 'return false when the date falls outside of the months given' do
            expect(subject).not_to include(Date.new(2015, 7, 31))
            expect(subject).not_to include(Date.new(2015, 11, 1))
          end
        end

        context 'start_month, end_month, start_day, and end_day given' do
          let(:args) { { start_month: 8, end_month: 10, start_day: 20, end_day: 10 } }

          it 'return true when the date falls on or after the start_day in the start_month' do
            expect(subject).to include(Date.new(2015, 8, 20))
            expect(subject).to include(Date.new(2015, 8, 31))
          end

          it 'return true when the date falls on or before the end_day in the end_month' do
            expect(subject).to include(Date.new(2015, 10, 1))
            expect(subject).to include(Date.new(2015, 10, 10))
          end

          it 'return true when the date falls on any day in a month between the start_month and end_month' do
            expect(subject).to include(Date.new(2015, 9, 1))
            expect(subject).to include(Date.new(2015, 9, 30))
          end

          it 'return false when the date falls before the start_day in the start_month' do
            expect(subject).not_to include(Date.new(2015, 8, 19))
          end

          it 'return false when the date falls after the end_day in the end_month' do
            expect(subject).not_to include(Date.new(2015, 10, 11))
          end

          it 'return false when the date falls outside of the months given' do
            expect(subject).not_to include(Date.new(2015, 7, 31))
            expect(subject).not_to include(Date.new(2015, 11, 1))
          end
        end
      end
    end
  end
end
