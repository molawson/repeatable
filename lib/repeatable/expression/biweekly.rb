module Repeatable
  module Expression
    class Biweekly < Date
      def initialize(weekday:, start_date: ::Date.today)
        @weekday = weekday
        @start_date = Date(start_date)
      end

      def include?(date)
        date >= start_date && (date - first_occurrence) % 14 == 0
      end

      private

      attr_reader :weekday, :start_date

      def first_occurrence
        @first_occurrence ||= find_first_occurrence
      end

      def find_first_occurrence
        return start_date if start_date.wday == weekday

        days_away = weekday - start_date.wday
        days_away += 7 if days_away < 0
        start_date + days_away
      end
    end
  end
end
