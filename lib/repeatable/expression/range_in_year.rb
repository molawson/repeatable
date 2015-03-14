module Repeatable
  module Expression
    class RangeInYear < Date
      def initialize(start_month:, end_month: start_month, start_day: 0, end_day: 0)
        @start_month = start_month
        @end_month = end_month
        @start_day = start_day
        @end_day = end_day
      end

      def include?(date)
        months_include?(date) || start_month_include?(date) || end_month_include?(date)
      end

      def to_h
        args = { start_month: start_month }
        args[:end_month] = end_month unless end_month == start_month
        args[:start_day] = start_day unless start_day.zero?
        args[:end_day] = end_day unless end_day.zero?
        { range_in_year: args }
      end

      private

      attr_reader :start_month, :end_month, :start_day, :end_day

      def months_include?(date)
        date.month > start_month && date.month < end_month
      end

      def start_month_include?(date)
        date.month == start_month && (start_day == 0 || date.day >= start_day)
      end

      def end_month_include?(date)
        date.month == end_month && (end_day == 0 || date.day <= end_day)
      end
    end
  end
end
