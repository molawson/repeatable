module Repeatable
  module Expression
    class Difference < Base
      def initialize(included:, excluded:)
        @included = included
        @excluded = excluded
      end

      def include?(date)
        return false if excluded.include?(date)
        included.include?(date)
      end

      def to_h
        Hash[hash_key, { included: included.to_h, excluded: excluded.to_h }]
      end

      def ==(other)
        return false unless other.is_a?(self.class)
        included == other.included && excluded == other.excluded
      end

      def difference(other)
        Difference.new(included: included, excluded: excluded + other)
      end
      alias - difference

      protected

      attr_reader :included
      attr_accessor :excluded
    end
  end
end
