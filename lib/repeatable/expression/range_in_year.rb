# typed: strict
module Repeatable
  module Expression
    class RangeInYear < Date
      sig {params(start_month: Integer, end_month: Integer, start_day: Integer, end_day: Integer).void}
      def initialize(start_month:, end_month: start_month, start_day: 0, end_day: 0)
        @start_month = T.let(start_month, Integer)
        @end_month = T.let(end_month, Integer)
        @start_day = T.let(start_day, Integer)
        @end_day = T.let(end_day, Integer)
      end

      sig {implementation.params(date: ::Date).returns(T::Boolean)}
      def include?(date)
        return true if months_include?(date)

        if start_month == end_month
          start_month_include?(date) && end_month_include?(date)
        else
          start_month_include?(date) || end_month_include?(date)
        end
      end

      sig {override.returns(T::Hash[Symbol, T.untyped])}
      def to_h
        args = { start_month: start_month }
        args[:end_month] = end_month unless end_month == start_month
        args[:start_day] = start_day unless start_day.zero?
        args[:end_day] = end_day unless end_day.zero?
        { range_in_year: args }
      end

      private

      sig {returns(Integer)}
      attr_reader :start_month

      sig {returns(Integer)}
      attr_reader :end_month

      sig {returns(Integer)}
      attr_reader :start_day

      sig {returns(Integer)}
      attr_reader :end_day

      sig {params(date: ::Date).returns(T::Boolean)}
      def months_include?(date)
        date.month > start_month && date.month < end_month
      end

      sig {params(date: ::Date).returns(T::Boolean)}
      def start_month_include?(date)
        date.month == start_month && (start_day == 0 || date.day >= start_day)
      end

      sig {params(date: ::Date).returns(T::Boolean)}
      def end_month_include?(date)
        date.month == end_month && (end_day == 0 || date.day <= end_day)
      end
    end
  end
end
