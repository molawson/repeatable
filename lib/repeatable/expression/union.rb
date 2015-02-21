module Repeatable
  module Expression
    class Union < Set
      def include?(date)
        elements.any? { |e| e.include?(date) }
      end
    end
  end
end
