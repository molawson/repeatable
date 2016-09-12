module Repeatable
  module Expression
    # Wraps an expression to make it "finished"
    # after a certain number of occurences
    # starting from a certain date
    class EndsAfter < Base
      def initialize(expression:, count:, from:)
        @expression = expression
        @count = count
        @from = Date(from)
      end

      def include?(date)
        date > from &&
          # I wonder what order of these two is more efficent:
          expression.include?(date) &&
          date <= last_date
          # Another option is `all_dates.include?(date)`,
          # since you're generating the whole list anyways
      end

      def to_h
        {
          ends_after: {
            count: count,
            from: from.to_s,
            expression: expression.to_h,
          }
        }
      end

      def hash
        count.hash + from.hash + expression.hash
      end

      def ==(other)
        other.is_a?(self.class) &&
          other.count == count &&
          other.from == from &&
          other.expression == expression
      end
      alias eql? ==


      protected

      attr_reader :expression, :count, :from

      private

      def last_date
        @last_date ||= begin
          schedule = Repeatable::Schedule.new(expression)
          dates = schedule.first(from, count)
          dates.last
        end
      end
    end
  end
end
