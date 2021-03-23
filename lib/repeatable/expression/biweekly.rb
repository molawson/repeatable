# typed: true
module Repeatable
  module Expression
    class Biweekly < Date
      def initialize(weekday:, start_after: ::Date.today)
        @weekday = weekday
        @start_after = Conversions::Date(start_after)
      end

      def include?(date)
        date >= start_after && (date - first_occurrence) % 14 == 0
      end

      private

      attr_reader :weekday, :start_after

      def first_occurrence
        @first_occurrence ||= find_first_occurrence
      end

      def find_first_occurrence
        days_away = weekday - start_after.wday
        days_away += 7 if days_away <= 0
        start_after + days_away
      end
    end
  end
end
