# typed: false
require "spec_helper"

module Repeatable
  describe LastDateOfMonth do
    include LastDateOfMonth

    describe "#last_date_of_month" do
      it "returns the last day of the month for a 28 day month" do
        date = Date.new(2017, 2, 12)
        expect(last_date_of_month(date)).to eq(Date.new(2017, 2, 28))
      end

      it "returns the last day of the month for a 29 day month" do
        date = Date.new(2016, 2, 20)
        expect(last_date_of_month(date)).to eq(Date.new(2016, 2, 29))
      end

      it "returns the last day of the month for a 30 day month" do
        date = Date.new(2017, 4, 9)
        expect(last_date_of_month(date)).to eq(Date.new(2017, 4, 30))
      end

      it "returns the last day of the month for a 31 day month" do
        date = Date.new(2017, 1, 2)
        expect(last_date_of_month(date)).to eq(Date.new(2017, 1, 31))
      end

      it "returns the last day of the month for a date that is the last day" do
        date = Date.new(2017, 1, 31)
        expect(last_date_of_month(date)).to eq(Date.new(2017, 1, 31))
      end
    end
  end
end
