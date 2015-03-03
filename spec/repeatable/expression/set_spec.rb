require 'spec_helper'

module Repeatable
  module Expression
    describe Set do
      let(:tuesday) { Repeatable::Expression::Weekday.new(weekday: 2)  }
      let(:thursday) { Repeatable::Expression::Weekday.new(weekday: 4)  }
      let(:tenth) { Repeatable::Expression::DayInMonth.new(day: 10) }

      describe '#initialize' do
        context 'no arguments' do
          it 'sets an empty elements array' do
            set = described_class.new
            expect(set.send(:elements)).to eq([])
          end
        end

        context 'multiple arguments' do
          it 'combines all arguments into elements array' do
            set = described_class.new(tuesday, tenth, thursday)
            expect(set.send(:elements)).to eq([tuesday, tenth, thursday])
          end
        end

        context 'single array of arguments' do
          it 'sets array of arguments as elements array' do
            set = described_class.new([tuesday, tenth, thursday])
            expect(set.send(:elements)).to eq([tuesday, tenth, thursday])
          end
        end
      end

      describe '#<<' do
        it 'returns the set object' do
          expect(subject << tenth).to be_a(Repeatable::Expression::Set)
        end

        context 'no existing elements' do
          subject { described_class.new }

          it 'adds the new element to the array' do
            subject << tenth
            expect(subject.send(:elements)).to eq([tenth])
          end
        end

        context 'existing elements' do
          subject { described_class.new(tuesday, thursday) }

          it 'appends the new element to the elements array' do
            subject << tenth
            expect(subject.send(:elements)).to eq([tuesday, thursday, tenth])
          end
        end
      end

      describe '#to_h' do
        it 'returns to_h representation of included elements' do
          set = described_class.new([tuesday, tenth, thursday])
          expect(set.to_h).to eq(set: [tuesday.to_h, tenth.to_h, thursday.to_h])
        end
      end
    end
  end
end
