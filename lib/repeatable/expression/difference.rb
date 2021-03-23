# typed: true
module Repeatable
  module Expression
    class Difference < Base
      def initialize(included:, excluded:)
        @included = included
        @excluded = excluded
      end

      def include?(date)
        included.include?(date) && !excluded.include?(date)
      end

      def to_h
        Hash[hash_key, {included: included.to_h, excluded: excluded.to_h}]
      end

      def ==(other)
        other.is_a?(self.class) &&
          included == other.included &&
          excluded == other.excluded
      end

      protected

      attr_reader :included, :excluded
    end
  end
end
