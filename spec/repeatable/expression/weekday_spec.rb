require 'spec_helper'

module Repeatable
  module Expression
    describe Weekday do
      subject { described_class.new(weekday: 4) }

      it_behaves_like 'an expression'

      describe '#include?' do
        it 'returns true for dates matching the weekday given' do
          expect(subject).to include(::Date.new(2015, 1, 1))
        end

        it 'returns false for dates not matching the weekday given' do
          expect(subject).not_to include(::Date.new(2015, 1, 2))
        end
      end

      describe '#to_h' do
        it 'returns a hash with the class name and arguments' do
          expect(subject.to_h).to eq(weekday: { weekday: 4 })
        end
      end
    end
  end
end
