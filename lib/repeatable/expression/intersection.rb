# typed: strict
module Repeatable
  module Expression
    class Intersection < Set
      sig {params(date: ::Date).returns(T::Boolean)}
      def include?(date)
        elements.all? { |e| e.include?(date) }
      end
    end
  end
end
