module Repeatable
  module Expression
    class RangeInYear < Base
      def initialize(start_month:, end_month: start_month, start_day: 0, end_day: 0)
        @start_month = start_month
        @end_month = end_month
        @start_day = start_day
        @end_day = end_day
      end

      def include?(date)
        months_include?(date) || start_month_include?(date) || end_month_include?(date)
      end

      private

      attr_reader :start_month, :end_month, :start_day, :end_day

      def months_include?(date)
        date.month > start_month && date.month < end_month
      end

      def start_month_include?(date)
        if date.month != start_month
          false
        elsif start_day == 0
          true
        else
          date.day >= start_day
        end
      end

      def end_month_include?(date)
        if date.month != end_month
          false
        elsif end_day == 0
          true
        else
          date.day <= end_day
        end
      end
    end
  end
end