module Repeatable
  module Expression
    class ExactDate < Date
      def initialize(date:)
        @date = Date(date)
      end

      def include?(other_date)
        date == other_date
      end

      private

      attr_reader :date
    end
  end
end
