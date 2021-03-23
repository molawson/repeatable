# typed: strict
module Repeatable
  module Expression
    class Base
      extend T::Sig

      sig { params(other: Object).returns(T::Boolean) }
      def self.===(other)
        case other
        when Class
          other.ancestors.include?(self)
        else
          super
        end
      end

      sig { params(_date: ::Date).returns(T::Boolean) }
      def include?(_date)
        fail(
          NotImplementedError,
          "Don't use Expression::Base directly. Subclasses must implement `#include?`"
        )
      end

      sig { returns(T::Hash[Symbol, T.untyped]) }
      def to_h
        fail(
          NotImplementedError,
          "Don't use Expression::Base directly. Subclasses must implement `#to_h`"
        )
      end

      sig { params(other: Expression::Base).returns(Expression::Union) }
      def union(other)
        Union.new(self, other)
      end
      alias_method :+, :union
      alias_method :|, :union

      sig { params(other: Expression::Base).returns(Expression::Intersection) }
      def intersection(other)
        Intersection.new(self, other)
      end
      alias_method :&, :intersection

      sig { params(other: T.untyped).returns(Expression::Difference) }
      def difference(other)
        Difference.new(included: self, excluded: other)
      end
      alias_method :-, :difference

      private

      sig { returns(T.untyped) }
      def hash_key
        T.must(T.must(self.class.name).split("::").last)
          .gsub(/(?<!\b)[A-Z]/) { "_#{T.must(Regexp.last_match)[0]}" }
          .downcase
          .to_sym
      end
    end
  end
end
