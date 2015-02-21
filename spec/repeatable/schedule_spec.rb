require 'spec_helper'

module Repeatable
  describe Schedule do
    subject { described_class.new(args) }

    context 'simple range' do
      let(:args) do
        {
          range_in_year: { start_month: 10, end_month: 12 }
        }
      end

      it 'works' do
        expect(subject.occurring?(Date.new(2015, 9, 30))).to eq(false)
        expect(subject.occurring?(Date.new(2015, 10, 1))).to eq(true)
        expect(subject.occurring?(Date.new(2015, 11, 15))).to eq(true)
        expect(subject.occurring?(Date.new(2015, 12, 31))).to eq(true)
        expect(subject.occurring?(Date.new(2015, 2, 23))).to eq(false)
      end
    end

    context 'set expression' do
      let(:args) do
        {
          union: [
            { day_in_month: { day: 23 } },
            { range_in_year: { start_month: 10, end_month: 12 } }
          ]
        }
      end

      it 'works' do
        expect(subject.occurring?(Date.new(2015, 9, 2))).to eq(false)
        expect(subject.occurring?(Date.new(2015, 9, 23))).to eq(true)
        expect(subject.occurring?(Date.new(2015, 10, 2))).to eq(true)
        expect(subject.occurring?(Date.new(2015, 10, 23))).to eq(true)
        expect(subject.occurring?(Date.new(2015, 11, 3))).to eq(true)
        expect(subject.occurring?(Date.new(2015, 11, 23))).to eq(true)
        expect(subject.occurring?(Date.new(2015, 12, 23))).to eq(true)
        expect(subject.occurring?(Date.new(2015, 12, 24))).to eq(true)
        expect(subject.occurring?(Date.new(2015, 1, 23))).to eq(true)
        expect(subject.occurring?(Date.new(2015, 1, 2))).to eq(false)
        expect(subject.next_occurrence(Date.new(2015, 9, 2))).to eq(Date.new(2015, 9, 23))
      end
    end

    context 'nested set expressions' do
      let(:args) do
        {
          intersection: [
            {
              union: [
                { day_in_month: { day: 23 } },
                { day_in_month: { day: 24 } }
              ]
            },
            { range_in_year: { start_month: 10, end_month: 12 } }
          ]
        }
      end

      it 'works' do
        expect(subject.occurring?(Date.new(2015, 9, 23))).to eq(false)
        expect(subject.occurring?(Date.new(2015, 10, 2))).to eq(false)
        expect(subject.occurring?(Date.new(2015, 10, 23))).to eq(true)
        expect(subject.occurring?(Date.new(2015, 11, 23))).to eq(true)
        expect(subject.occurring?(Date.new(2015, 12, 23))).to eq(true)
        expect(subject.occurring?(Date.new(2015, 12, 24))).to eq(true)
        expect(subject.occurring?(Date.new(2015, 12, 25))).to eq(false)
        expect(subject.occurring?(Date.new(2015, 1, 23))).to eq(false)
        expect(subject.next_occurrence(Date.new(2015, 9, 2))).to eq(Date.new(2015, 10, 23))
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

    context 'invalid arg format' do
      context 'multiple keys in outer hash' do
        let(:args) do
          {
            day_in_month: { day: 23 },
            range_in_year: { start_month: 10, end_month: 12 }
          }
        end

        it 'raises an invalid expression error' do
          expect { subject }.to raise_error(RuntimeError).with_message(/Invalid expression/)
        end
      end

      context 'multiple keys in inner hash' do
        let(:args) do
          {
            union: [
              day_in_month: { day: 23 },
              range_in_year: { start_month: 10, end_month: 12 }
            ]
          }
        end

        it 'raises an invalid expression error' do
          expect { subject }.to raise_error(RuntimeError).with_message(/Invalid expression/)
        end
      end

      context 'key does not match existing class' do
        let(:args) { { asdf: { foo: 'bar' } } }

        it 'raises an unknown mapping error' do
          expect { subject }.to raise_error(RuntimeError).with_message(/Unknown mapping/)
        end
      end
    end
  end
end
