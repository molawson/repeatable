# typed: strict
module Repeatable
  module Expression
    class Difference < Base
      sig {params(included: Expression::Base, excluded: Expression::Base).void}
      def initialize(included:, excluded:)
        @included = T.let(included, Expression::Base)
        @excluded = T.let(excluded, Expression::Base)
      end

      sig {implementation.params(date: ::Date).returns(T::Boolean)}
      def include?(date)
        included.include?(date) && !excluded.include?(date)
      end

      sig {implementation.returns(T::Hash[Symbol, T.untyped])}
      def to_h
        { hash_key => { included: included.to_h, excluded: excluded.to_h } }
      end

      sig {params(other: Object).returns(T::Boolean)}
      def ==(other)
        other.is_a?(self.class) &&
          included == other.included &&
          excluded == other.excluded
      end

      protected

      sig {returns(Expression::Base)}
      attr_reader :included

      sig {returns(Expression::Base)}
      attr_reader :excluded
    end
  end
end
