module Repeatable
  module Expression
    class Base
      def self.===(other)
        other.ancestors.include?(self)
      end

      def include?(_date)
        fail(
          NotImplementedError,
          "Don't use Expression::Base directly. Subclasses should implement `#include?`"
        )
      end
    end
  end
end
