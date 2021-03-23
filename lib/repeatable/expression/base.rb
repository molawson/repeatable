# typed: false
module Repeatable
  module Expression
    class Base
      def self.===(other)
        case other
        when Class
          other.ancestors.include?(self)
        else
          super
        end
      end

      def include?(_date)
        fail(
          NotImplementedError,
          "Don't use Expression::Base directly. Subclasses must implement `#include?`"
        )
      end

      def to_h
        fail(
          NotImplementedError,
          "Don't use Expression::Base directly. Subclasses must implement `#to_h`"
        )
      end

      def union(other)
        Union.new(self, other)
      end
      alias_method :+, :union
      alias_method :|, :union

      def intersection(other)
        Intersection.new(self, other)
      end
      alias_method :&, :intersection

      def difference(other)
        Difference.new(included: self, excluded: other)
      end
      alias_method :-, :difference

      private

      def hash_key
        self.class.name.split("::").last
          .gsub(/(?<!\b)[A-Z]/) { "_#{Regexp.last_match[0]}" }
          .downcase
          .to_sym
      end
    end
  end
end
