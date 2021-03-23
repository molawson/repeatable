# typed: strict
module Repeatable
  module Expression
    class RangeInYear < Date
      extend T::Sig

      sig do
        params(
          start_month: Integer,
          end_month: Integer,
          start_day: Integer,
          end_day: Integer
        ).void
      end
      def initialize(start_month:, end_month: start_month, start_day: 0, end_day: 0)
        @start_month = start_month
        @end_month = end_month
        @start_day = start_day
        @end_day = end_day
      end

      sig { override.params(date: ::Date).returns(T::Boolean) }
      def include?(date)
        return true if months_include?(date)

        if start_month == end_month
          start_month_include?(date) && end_month_include?(date)
        else
          start_month_include?(date) || end_month_include?(date)
        end
      end

      private

      sig { returns(Integer) }
      attr_reader :start_month

      sig { returns(Integer) }
      attr_reader :end_month

      sig { returns(Integer) }
      attr_reader :start_day

      sig { returns(Integer) }
      attr_reader :end_day

      sig { params(date: ::Date).returns(T::Boolean) }
      def months_include?(date)
        date.month > start_month && date.month < end_month
      end

      sig { params(date: ::Date).returns(T::Boolean) }
      def start_month_include?(date)
        date.month == start_month && (start_day == 0 || date.day >= start_day)
      end

      sig { params(date: ::Date).returns(T::Boolean) }
      def end_month_include?(date)
        date.month == end_month && (end_day == 0 || date.day <= end_day)
      end

      sig { override.returns(T::Hash[Symbol, Integer]) }
      def hash_value
        args = {start_month: start_month}
        args[:end_month] = end_month unless end_month == start_month
        args[:start_day] = start_day unless start_day.zero?
        args[:end_day] = end_day unless end_day.zero?
        args
      end
    end
  end
end
