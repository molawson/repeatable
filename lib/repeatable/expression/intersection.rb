module Repeatable
  module Expression
    class Intersection < Set
      def include?(date)
        elements.all? { |e| e.include?(date) }
      end

      def intersection(other)
        if other.is_a?(Intersection)
          Intersection.new(*elements, *other.elements)
        else
          Intersection.new(other, *elements)
        end
      end
      alias | intersection
    end
  end
end
