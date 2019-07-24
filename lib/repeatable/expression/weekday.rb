# typed: strict
module Repeatable
  module Expression
    class Weekday < Date
      sig {params(weekday: Integer).void}
      def initialize(weekday:)
        @weekday = T.let(weekday, Integer)
      end

      sig {params(date: ::Date).returns(T::Boolean)}
      def include?(date)
        date.wday == weekday
      end

      private

      sig {returns(Integer)}
      attr_reader :weekday
    end
  end
end
