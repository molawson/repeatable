require 'active_support/core_ext/string/inflections'

module Repeatable
  class Schedule
    def initialize(arg)
      case arg
      when Repeatable::Expression::Base
        @expression = arg
      when Hash
        @expression = Parser.call(arg)
      else
        fail(ParseError, "Can't build a Repeatable::Schedule from #{arg.class}")
      end
    end

    def occurrences(start_date, end_date)
      start_date = Date(start_date)
      end_date = Date(end_date)

      fail ArgumentError, 'end_date must be after start_date' if end_date < start_date
      (start_date..end_date).select { |date| include?(date) }
    end

    def next_occurrence(start_date = Date.today)
      date = Date(start_date)
      until include?(date)
        date = date.next_day
      end
      date
    end

    def include?(date = Date.today)
      date = Date(date)
      expression.include?(date)
    end

    def to_h
      expression.to_h
    end

    private

    attr_reader :expression
  end
end
