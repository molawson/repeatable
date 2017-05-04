module Repeatable
  module Expression
    class DayInMonth < Date
      include LastDateOfMonth

      def initialize(day:)
        @day = day
      end

      def include?(date)
        if day < 0
          date - last_date_of_month(date) - 1 == day
        else
          date.day == day
        end
      end

      private

      attr_reader :day
    end
  end
end
