# typed: strict
module Repeatable
  module Expression
    class Union < Set
      sig { params(elements: Expression::Base).void }
      def initialize(*elements)
        other_unions, not_unions = elements.partition { |e| e.is_a?(self.class) }
        other_unions = T.cast(other_unions, T::Array[Expression::Union])
        super(other_unions.flat_map(&:elements) + not_unions)
      end

      sig { override.params(date: ::Date).returns(T::Boolean) }
      def include?(date)
        elements.any? { |e| e.include?(date) }
      end
    end
  end
end
