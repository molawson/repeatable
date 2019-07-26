# typed: strict
module Repeatable
  module Expression
    class ExactDate < Date
      sig {params(date: BasicObject).void}
      def initialize(date:)
        @date = T.let(Date(date), ::Date)
      end

      sig {implementation.params(other_date: ::Date).returns(T::Boolean)}
      def include?(other_date)
        date == other_date
      end

      private

      sig {returns(::Date)}
      attr_reader :date
    end
  end
end
