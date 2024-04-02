# typed: strict
module Repeatable
  module Expression
    class Daily < Date
      sig { override.params(_date: ::Date).returns(T::Boolean) }
      def include?(_date)
        true
      end
    end
  end
end
