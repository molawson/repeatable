require 'spec_helper'

module Repeatable
  module Expression
    describe Base do
      describe '.===' do
        context 'other is a class' do
          it 'returns true when described_class is an ancestor of the given class' do
            expect(described_class === Repeatable::Expression::Set).to eq(true)
          end

          it 'returns false when described_class is not an ancestor of the given class' do
            expect(described_class === Repeatable::Schedule).to eq(false)
          end
        end

        context 'other is an instance of a class' do
          it 'uses default ==== (is_a?) behavior' do
            expect(described_class === Repeatable::Expression::Set.new).to eq(true)
            expect(described_class === '').to eq(false)
          end
        end
      end

      describe '#include?' do
        it 'raises a NotImplemented Error' do
          expect { subject.include?('anything') }.to raise_error(NotImplementedError)
        end
      end

      describe '#to_h' do
        it 'raises a NotImplemented Error' do
          expect { subject.to_h }.to raise_error(NotImplementedError)
        end
      end
    end
  end
end
