module Repeatable
  module Expression
    class DayInMonth < Date
      def initialize(day:)
        @day = day
      end

      def include?(date)
        if day == :last
          date.next_day.month != date.month
        else
          date.day == day
        end
      end

      private

      attr_reader :day
    end
  end
end
