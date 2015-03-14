require 'spec_helper'

module Repeatable
  describe Parser do
    include ScheduleArguments

    describe '#call' do
      subject { described_class.new(arg).call }

      context 'complex set expression' do
        let(:arg) { nested_set_expression_hash }

        it 'builds the expected Expression object' do
          expect(subject).to eq(nested_set_expression_object)
        end
      end

      context 'with string keys' do
        let(:arg) { stringified_set_expression_hash }

        it 'does not blow up' do
          expect { subject }.not_to raise_error
        end
      end

      context 'invalid hash format' do
        context 'multiple keys in outer hash' do
          let(:arg) do
            {
              day_in_month: { day: 23 },
              range_in_year: { start_month: 10, end_month: 12 }
            }
          end

          it 'raises an invalid expression error' do
            expect { subject }.to raise_error(Repeatable::ParseError).with_message(/Invalid expression/)
          end
        end

        context 'multiple keys in inner hash' do
          let(:arg) do
            {
              union: [
                day_in_month: { day: 23 },
                range_in_year: { start_month: 10, end_month: 12 }
              ]
            }
          end

          it 'raises an invalid expression error' do
            expect { subject }.to raise_error(Repeatable::ParseError).with_message(/Invalid expression/)
          end
        end

        context 'key does not match existing class' do
          let(:arg) { { asdf: { foo: 'bar' } } }

          it 'raises an unknown mapping error' do
            expect { subject }.to raise_error(Repeatable::ParseError).with_message(/Unknown mapping/)
          end
        end
      end
    end
  end
end
