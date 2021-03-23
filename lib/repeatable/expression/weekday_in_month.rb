# typed: strict
module Repeatable
  module Expression
    class WeekdayInMonth < Date
      extend T::Sig
      include LastDateOfMonth

      sig { params(weekday: Integer, count: Integer).void }
      def initialize(weekday:, count:)
        @weekday = weekday
        @count = count
      end

      sig { override.params(date: ::Date).returns(T::Boolean) }
      def include?(date)
        day_matches?(date) && week_matches?(date)
      end

      private

      sig { returns(Integer) }
      attr_reader :weekday

      sig { returns(Integer) }
      attr_reader :count

      sig { params(date: ::Date).returns(T::Boolean) }
      def day_matches?(date)
        date.wday == weekday
      end

      sig { params(date: ::Date).returns(T::Boolean) }
      def week_matches?(date)
        if negative_count?
          week_from_end(date) == count
        else
          week_from_beginning(date) == count
        end
      end

      sig { params(date: ::Date).returns(Integer) }
      def week_from_beginning(date)
        week_in_month(date.day - 1)
      end

      sig { params(date: ::Date).returns(Integer) }
      def week_from_end(date)
        -week_in_month(last_date_of_month(date).day - date.day)
      end

      sig { params(zero_indexed_day: Integer).returns(Integer) }
      def week_in_month(zero_indexed_day)
        (zero_indexed_day / 7) + 1
      end

      sig { returns(T::Boolean) }
      def negative_count?
        count < 0
      end
    end
  end
end
