require 'spec_helper'

module Repeatable
  module Expression
    describe Base do
      describe '.===' do
        it 'returns true when described_class is an ancestor of the given class' do
          expect(described_class === Repeatable::Expression::Set).to eq(true)
        end

        it 'returns false when described_class is not an ancestor of the given class' do
          expect(described_class === Repeatable::Schedule).to eq(false)
        end
      end

      describe '#include?' do
        it 'raises a NotImplemented Error' do
          expect { subject.include?('anything') }.to raise_error(NotImplementedError)
        end
      end
    end
  end
end
