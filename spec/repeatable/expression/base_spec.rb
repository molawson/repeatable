require "spec_helper"

module Repeatable
  module Expression
    describe Base do
      describe ".===" do
        context "other is a class" do
          it "returns true when described_class is an ancestor of the given class" do
            expect(described_class === Repeatable::Expression::Set).to eq(true)
          end

          it "returns false when described_class is not an ancestor of the given class" do
            expect(described_class === Repeatable::Schedule).to eq(false)
          end
        end

        context "other is an instance of a class" do
          it "uses default ==== (is_a?) behavior" do
            expect(described_class === Repeatable::Expression::Set.new).to eq(true)
            expect(described_class === "").to eq(false)
          end
        end
      end

      describe "#include?" do
        it "raises a NotImplemented Error" do
          expect { subject.include?("anything") }.to raise_error(NotImplementedError)
        end
      end

      describe "#to_h" do
        it "raises a NotImplemented Error" do
          expect { subject.to_h }.to raise_error(NotImplementedError)
        end
      end

      describe "set operators" do
        describe "#union, #+ and #|" do
          let(:saturdays) { Weekday.new(weekday: 6) }
          let(:sundays) { Weekday.new(weekday: 0) }
          let(:weekends) { Union.new(saturdays, sundays) }

          it "returns a Union of the two expressions" do
            expect(saturdays.union(sundays)).to eq(weekends)
            expect(sundays.union(saturdays)).to eq(weekends)
            expect(saturdays + sundays).to eq(weekends)
            expect(sundays + saturdays).to eq(weekends)
            expect(saturdays | sundays).to eq(weekends)
            expect(sundays | saturdays).to eq(weekends)
          end
        end

        describe "#intersection and #&" do
          let(:fourths) { DayInMonth.new(day: 4) }
          let(:july) { RangeInYear.new(start_month: 7) }
          let(:fourth_of_july) { Intersection.new(july, fourths) }

          it "returns an Intersection of the two expressions" do
            expect(fourths.intersection(july)).to eq(fourth_of_july)
            expect(july.intersection(fourths)).to eq(fourth_of_july)
            expect(fourths & july).to eq(fourth_of_july)
            expect(july & fourths).to eq(fourth_of_july)
          end
        end

        describe "#difference and #-" do
          let(:mondays) { Weekday.new(weekday: 1) }
          let(:tuesdays) { Weekday.new(weekday: 2) }
          let(:wednesdays) { Weekday.new(weekday: 3) }
          let(:thursdays) { Weekday.new(weekday: 4) }
          let(:fridays) { Weekday.new(weekday: 5) }
          let(:workdays) { Union.new(mondays, tuesdays, wednesdays, thursdays, fridays) }
          let(:summer_workdays) { Difference.new(included: workdays, excluded: fridays) }

          it "returns a Difference of the two expressions" do
            expect(workdays.difference(fridays)).to eq(summer_workdays)
            expect(workdays - fridays).to eq(summer_workdays)
          end
        end
      end
    end
  end
end
