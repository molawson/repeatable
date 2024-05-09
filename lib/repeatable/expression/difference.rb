# typed: strict

module Repeatable
  module Expression
    class Difference < Base
      sig { params(included: Expression::Base, excluded: Expression::Base).void }
      def initialize(included:, excluded:)
        @included = included
        @excluded = excluded
      end

      sig { override.params(date: ::Date).returns(T::Boolean) }
      def include?(date)
        included.include?(date) && !excluded.include?(date)
      end

      sig { params(other: Object).returns(T::Boolean) }
      def ==(other)
        other.is_a?(self.class) &&
          included == other.included &&
          excluded == other.excluded
      end

      protected

      sig { returns(Expression::Base) }
      attr_reader :included

      sig { returns(Expression::Base) }
      attr_reader :excluded

      sig { override.returns(Types::SymbolHash) }
      def hash_value
        {included: included.to_h, excluded: excluded.to_h}
      end
    end
  end
end
