# typed: strict
module Repeatable
  module Expression
    class Set < Base
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

      sig { params(other: Object).returns(T::Boolean) }
      def ==(other)
        other.is_a?(self.class) &&
          elements.size == other.elements.size &&
          other.elements.all? { |e| elements.include?(e) }
      end

      private

      sig { override.returns(T::Array[Types::SymbolHash]) }
      def hash_value
        elements.map(&:to_h)
      end
    end
  end
end
