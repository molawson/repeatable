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

      fail(ArgumentError, 'end_date must be equal to or after start_date') if end_date < start_date

      (start_date..end_date).select { |date| include?(date) }
    end

    def next_occurrence(start_date = Date.today, include_start: false, limit: 36525)
      date = Date(start_date)

      return date if include_start && include?(date)

      1.step do |i|
        date = date.next_day

        break date if include?(date)
        break if i == limit.to_i
      end
    end

    def include?(date = Date.today)
      date = Date(date)
      expression.include?(date)
    end

    def to_h
      expression.to_h
    end

    def ==(other)
      other.is_a?(self.class) && expression == other.expression
    end

    protected

    attr_reader :expression
  end
end
