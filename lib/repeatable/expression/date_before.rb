module Repeatable
  module Expression
    class DateBefore < Date
      def initialize(boundary_date:, include_boundary: true)
        @boundary_date = Date(boundary_date)
        @include_boundary = include_boundary
      end

      def include?(date)
        if include_boundary
          date < (boundary_date.next_day)
        else
          date < boundary_date
        end
      end

      private

      attr_reader :boundary_date, :include_boundary
    end
  end
end
