# typed: true
module Repeatable
  module Expression
    class WeekdayInMonth < Date
      include LastDateOfMonth

      def initialize(weekday:, count:)
        @weekday = weekday
        @count = count
      end

      def include?(date)
        day_matches?(date) && week_matches?(date)
      end

      private

      attr_reader :weekday, :count

      def day_matches?(date)
        date.wday == weekday
      end

      def week_matches?(date)
        if negative_count?
          week_from_end(date) == count
        else
          week_from_beginning(date) == count
        end
      end

      def week_from_beginning(date)
        week_in_month(date.day - 1)
      end

      def week_from_end(date)
        -week_in_month(last_date_of_month(date).day - date.day)
      end

      def week_in_month(zero_indexed_day)
        (zero_indexed_day / 7) + 1
      end

      def negative_count?
        count < 0
      end
    end
  end
end
