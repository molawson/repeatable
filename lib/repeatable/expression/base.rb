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
        if other.is_a?(Union)
          other.union(self)
        else
          Union.new(self, other)
        end
      end
      alias + union

      def intersection(other)
        if other.is_a?(Intersection)
          other.intersection(self)
        else
          Intersection.new(self, other)
        end
      end
      alias | intersection

      def difference(other)
        Difference.new(included: self, excluded: other)
      end
      alias - difference

      private

      def hash_key
        self.class.name.split('::').last
          .gsub(/(?<!\b)[A-Z]/) { "_#{Regexp.last_match[0]}" }
          .downcase
          .to_sym
      end
    end
  end
end
