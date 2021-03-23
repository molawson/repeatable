# typed: true
module Repeatable
  module Expression
    class Intersection < Set
      def initialize(*elements)
        other_intersection, not_intersection = elements.partition { |e| e.is_a?(self.class) }
        super(other_intersection.flat_map(&:elements) + not_intersection)
      end

      def include?(date)
        elements.all? { |e| e.include?(date) }
      end
    end
  end
end
