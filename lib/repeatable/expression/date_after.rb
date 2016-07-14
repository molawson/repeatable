module Repeatable
  module Expression
    class DateAfter < Date
      def initialize(boundary_date:, include_boundary: true)
        @boundary_date = Date(boundary_date)
        @include_boundary = include_boundary
      end

      def include?(date)
        if include_boundary
          (boundary_date.prev_day) < date
        else
          boundary_date < date
        end
      end

      private

      attr_reader :boundary_date, :include_boundary
    end
  end
end
