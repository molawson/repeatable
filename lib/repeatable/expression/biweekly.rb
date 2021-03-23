# typed: strict
module Repeatable
  module Expression
    class Biweekly < Date
      extend T::Sig

      sig { params(weekday: Integer, start_after: Object).void }
      def initialize(weekday:, start_after: ::Date.today)
        @weekday = weekday
        @start_after = T.let(Conversions::Date(start_after), ::Date)
        @first_occurrence = T.let(find_first_occurrence, ::Date)
      end

      sig { params(date: ::Date).returns(T::Boolean) }
      def include?(date)
        date >= start_after && (date - first_occurrence) % 14 == 0
      end

      private

      sig { returns(Integer) }
      attr_reader :weekday

      sig { returns(::Date) }
      attr_reader :start_after

      sig { returns(::Date) }
      attr_reader :first_occurrence

      sig { returns(::Date) }
      def find_first_occurrence
        days_away = weekday - start_after.wday
        days_away += 7 if days_away <= 0
        start_after + days_away
      end
    end
  end
end
