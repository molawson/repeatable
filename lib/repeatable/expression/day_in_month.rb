# typed: strict
module Repeatable
  module Expression
    class DayInMonth < Date
      include LastDateOfMonth

      sig {params(day: Integer).void}
      def initialize(day:)
        @day = T.let(day, Integer)
      end

      sig {implementation.params(date: ::Date).returns(T::Boolean)}
      def include?(date)
        if day < 0
          date - last_date_of_month(date) - 1 == day
        else
          date.day == day
        end
      end

      private

      sig {returns(Integer)}
      attr_reader :day
    end
  end
end
