module Repeatable
  module Expression
    # This expression wraps an existing expression,
    # giving it an specific ending date.
    class EndsAt < Base
      def initialize(expression:, ends_at:)
        @expression = expression
        @ends_at = Date(ends_at)
      end

      def include?(date)
        date < ends_at && expression.include?(date)
      end

      def to_h
        {
          ends_at: {
            ends_at: ends_at.to_s,
            expression: expression.to_h,
          }
        }
      end

      def ==(other)
        other.is_a?(self.class) &&
          other.ends_at == ends_at &&
          other.expression == expression
      end

      alias eql? ==

      def hash
        ends_at.hash + expression.hash
      end

      protected

      attr_reader :ends_at, :expression
    end
  end
end
