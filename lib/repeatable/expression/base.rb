# typed: strict
module Repeatable
  module Expression
    class Base
      extend T::Sig
      extend T::Helpers

      abstract!

      sig { params(other: Object).returns(T::Boolean) }
      def self.===(other)
        case other
        when Class
          other.ancestors.include?(self)
        else
          super
        end
      end

      sig { abstract.params(date: ::Date).returns(T::Boolean) }
      def include?(date)
      end

      sig do
        returns(
          T::Hash[
            Symbol,
            T.any(
              T::Hash[Symbol, T.untyped],
              T::Array[T::Hash[Symbol, T.untyped]]
            )
          ]
        )
      end
      def to_h
        {hash_key => hash_value}
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

      sig { returns(Symbol) }
      def hash_key
        T.must(T.must(self.class.name).split("::").last)
          .gsub(/(?<!\b)[A-Z]/) { "_#{T.must(Regexp.last_match)[0]}" }
          .downcase
          .to_sym
      end

      sig do
        abstract.returns(
          T.any(
            T::Hash[Symbol, T.untyped],
            T::Array[T::Hash[Symbol, T.untyped]]
          )
        )
      end
      def hash_value
      end
    end
  end
end
