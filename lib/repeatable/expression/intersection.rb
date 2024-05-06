# typed: strict

module Repeatable
  module Expression
    class Intersection < Set
      sig { params(elements: T.any(Expression::Base, T::Array[Expression::Base])).void }
      def initialize(*elements)
        other_intersections, not_intersections = elements.partition { |e| e.is_a?(self.class) }
        other_intersections = T.cast(other_intersections, T::Array[Expression::Intersection])
        super(other_intersections.flat_map(&:elements).concat(not_intersections))
      end

      sig { override.params(date: ::Date).returns(T::Boolean) }
      def include?(date)
        elements.all? { |e| e.include?(date) }
      end
    end
  end
end
