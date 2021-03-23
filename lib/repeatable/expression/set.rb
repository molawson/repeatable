# typed: strict
module Repeatable
  module Expression
    class Set < Base
      extend T::Sig

      abstract!

      sig { returns(T::Array[Expression::Base]) }
      attr_reader :elements

      sig { params(elements: T.any(Expression::Base, T::Array[Expression::Base])).void }
      def initialize(*elements)
        @elements = T.let(elements.flatten.uniq, T::Array[Expression::Base])
      end

      sig { params(element: T.untyped).returns(Repeatable::Expression::Set) }
      def <<(element)
        elements << element unless elements.include?(element)
        self
      end

      sig { override.returns(T::Hash[Symbol, T.untyped]) }
      def to_h
        Hash[hash_key, elements.map(&:to_h)]
      end

      sig { params(other: Object).returns(T::Boolean) }
      def ==(other)
        other.is_a?(self.class) &&
          elements.size == other.elements.size &&
          other.elements.all? { |e| elements.include?(e) }
      end
    end
  end
end
