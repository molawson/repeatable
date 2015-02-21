module Repeatable
  module Expression
    class Intersection < Set
      def include?(date)
        elements.all? { |e| e.include?(date) }
      end
    end
  end
end
