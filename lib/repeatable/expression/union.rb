module Repeatable
  module Expression
    class Union < Set
      def include?(date)
        elements.any? { |e| e.include?(date) }
      end

      def union(other)
        if other.is_a?(Union)
          Union.new(*elements, *other.elements)
        else
          Union.new(other, *elements)
        end
      end
      alias + union
    end
  end
end
