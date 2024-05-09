# typed: strict

module Repeatable
  module Expression
    class ExactDate < Date
      sig { params(date: Object).void }
      def initialize(date:)
        @date = T.let(Conversions::Date(date), ::Date)
      end

      sig { override.params(other_date: ::Date).returns(T::Boolean) }
      def include?(other_date)
        date == other_date
      end

      private

      sig { returns(::Date) }
      attr_reader :date
    end
  end
end
