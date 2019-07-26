# typed: strict
module Repeatable
  module Expression
    class ExactDate < Date
      sig {params(date: T.untyped).void}
      def initialize(date:)
        @date = T.let(Date(date), ::Date)
      end

      sig {implementation.params(other_date: ::Date).returns(T::Boolean)}
      def include?(other_date)
        date == other_date
      end

      private

      sig {returns(T.untyped)}
      attr_reader :date
    end
  end
end
