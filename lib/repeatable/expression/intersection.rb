# typed: strong
module Repeatable
  module Expression
    class Intersection < Set
      sig {implementation.params(date: ::Date).returns(T::Boolean)}
      def include?(date)
        elements.all? { |e| e.include?(date) }
      end
    end
  end
end
