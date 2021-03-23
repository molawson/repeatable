# typed: true
module Repeatable
  module Expression
    class Union < Set
      def initialize(*elements)
        other_unions, not_unions = elements.partition { |e| e.is_a?(self.class) }
        super(other_unions.flat_map(&:elements) + not_unions)
      end

      def include?(date)
        elements.any? { |e| e.include?(date) }
      end
    end
  end
end
