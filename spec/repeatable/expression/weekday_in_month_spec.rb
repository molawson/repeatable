require 'spec_helper'

module Repeatable
  module Expression
    describe WeekdayInMonth do
      subject { described_class.new(weekday: 0, count: 1) }

      it_behaves_like 'an expression'

      describe '#include?' do
        context 'weekday matches' do
          it 'returns true for dates matching the week given' do
            expect(subject).to include(Date.new(2015, 1, 4))
          end

          it 'returns false for dates not matching the week given' do
            expect(subject).not_to include(Date.new(2015, 1, 11))
          end
        end

        context 'weekday does not match' do
          it 'returns false for dates matching the week given' do
            expect(subject).not_to include(Date.new(2015, 1, 1))
          end

          it 'returns false for dates not matching the week given' do
            expect(subject).not_to include(Date.new(2015, 1, 12))
          end
        end
      end
    end
  end
end
