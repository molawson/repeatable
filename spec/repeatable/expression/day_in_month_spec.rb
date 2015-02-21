require 'spec_helper'

module Repeatable
  module Expression
    describe DayInMonth do
      describe '#include?' do
        subject { described_class.new(day: 21) }

        it 'returns true for dates matching the day given' do
          expect(subject).to include(Date.new(2015, 1, 21))
        end

        it 'returns false for dates not matching the day given' do
          expect(subject).not_to include(Date.new(2015, 1, 22))
        end
      end
    end
  end
end
