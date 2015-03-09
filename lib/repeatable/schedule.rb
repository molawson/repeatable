require 'active_support/core_ext/string/inflections'

module Repeatable
  class Schedule
    def initialize(args)
      case args
      when Hash
        @expression = build_expression(args)
      when Repeatable::Expression::Base
        @expression = args
      else
        fail ArgumentError, "Can't build a Repeatable::Schedule from #{args.class}"
      end
    end

    def occurrences(start_date, end_date)
      start_date = Date(start_date)
      end_date = Date(end_date)
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

    def build_expression(hash)
      if hash.length != 1
        fail ParseError, "Invalid expression: '#{hash}' must have single key and value"
      else
        expression_for(*hash.first)
      end
    end

    def expression_for(key, value)
      klass = "repeatable/expression/#{key}".classify.safe_constantize
      case klass
      when nil
        fail ParseError, "Unknown mapping: Can't map key '#{key.inspect}' to an expression class"
      when Repeatable::Expression::Set
        args = value.map { |hash| build_expression(hash) }
        klass.new(*args)
      else
        klass.new(symbolize_keys(value))
      end
    end

    def symbolize_keys(hash)
      hash.each_with_object({}) { |(k, v), a| a[k.to_sym] = v }
    end
  end
end
