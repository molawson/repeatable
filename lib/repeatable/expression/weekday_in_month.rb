module Repeatable
  module Expression
    class WeekdayInMonth < Date
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
        week_in_month(date) == count
      end

      def week_in_month(date)
        negative_count = count < 0
        zero_indexed_day = if negative_count
                             last_date_of_month(date).day - date.day
                           else
                             date.day - 1
                           end
        zero_indexed_week = zero_indexed_day / 7

        (negative_count ? -1 : 1) * (zero_indexed_week + 1)
      end

      def last_date_of_month(date)
        next_month = date.next_month
        first_day_of_next_month = ::Date.new(next_month.year, next_month.month, 1)
        first_day_of_next_month.prev_day
      end
    end
  end
end
