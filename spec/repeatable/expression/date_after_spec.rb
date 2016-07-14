require 'spec_helper'

module Repeatable
  module Expression
    describe DateAfter do
      subject { described_class.new(args) }
      let(:args) { { boundary_date: boundary_date, include_boundary: include_boundary } }
      let(:boundary_date) { ::Date.new(2016, 8, 25) }

      context 'include boundary is false' do
        let(:include_boundary) { false }

        it 'does not include a far-past date before the boundary date' do
          expect(subject).not_to include(::Date.new(2015, 8, 26))
        end

        it 'does not include the date immediately before the boundary date' do
          expect(subject).not_to include(::Date.new(2016, 8, 24))
        end

        it 'does not include the boundary date' do
          expect(subject).not_to include(::Date.new(2016, 8, 25))
        end

        it 'includes the date immediate after the boundary date' do
          expect(subject).to include(::Date.new(2016, 8, 26))
        end

        it 'includes a far-future date after the boundary date' do
          expect(subject).to include(::Date.new(2017, 8, 24))
        end
      end

      context 'include_boundary is true' do
        let(:include_boundary) { true }

        it 'does not include a far-past date before the boundary date' do
          expect(subject).not_to include(::Date.new(2015, 8, 26))
        end

        it 'does not include the date immediately before the boundary date' do
          expect(subject).not_to include(::Date.new(2016, 8, 24))
        end

        it 'includes the boundary date' do
          expect(subject).to include(::Date.new(2016, 8, 25))
        end

        it 'includes the date immediate after the boundary date' do
          expect(subject).to include(::Date.new(2016, 8, 26))
        end

        it 'includes a far-future date after the boundary date' do
          expect(subject).to include(::Date.new(2017, 8, 24))
        end
      end
    end
  end
end
