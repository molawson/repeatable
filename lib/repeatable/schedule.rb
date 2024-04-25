# typed: strict
module Repeatable
  class Schedule
    extend T::Sig

    sig { params(arg: Object).void }
    def initialize(arg)
      case arg
      when Repeatable::Expression::Base
        @expression = T.let(arg, Expression::Base)
      when Hash
        @expression = Parser.call(arg)
      else
        fail(ParseError, "Can't build a Repeatable::Schedule from #{arg.class}")
      end
    end

    sig { params(start_date: Object, end_date: Object).returns(T::Array[::Date]) }
    def occurrences(start_date, end_date)
      start_date = Conversions::Date(start_date)
      end_date = Conversions::Date(end_date)

      fail(ArgumentError, "end_date must be equal to or after start_date") if end_date < start_date

      (start_date..end_date).select { |date| include?(date) }
    end

    sig { params(start_date: Object, include_start: T::Boolean, limit: Integer).returns(T.nilable(::Date)) }
    def next_occurrence(start_date = Date.today, include_start: false, limit: 36525)
      date = Conversions::Date(start_date)

      return date if include_start && include?(date)

      result = T.let(nil, T.nilable(Date))
      1.step(limit) do |i|
        date = date.next_day

        if include?(date)
          result = date
          break
        end
      end
      result
    end

    sig { params(date: Object).returns(T::Boolean) }
    def include?(date = Date.today)
      date = Conversions::Date(date)
      expression.include?(date)
    end

    sig { returns(T::Hash[Symbol, T.any(Types::SymbolHash, T::Array[Types::SymbolHash])]) }
    def to_h
      expression.to_h
    end

    sig { params(_keys: T.nilable(T::Array[Symbol])).returns(T::Hash[Symbol, T.any(Types::SymbolHash, T::Array[Types::SymbolHash])]) }
    def deconstruct_keys(_keys)
      to_h
    end

    sig { params(other: Object).returns(T::Boolean) }
    def ==(other)
      other.is_a?(self.class) && expression == other.expression
    end

    protected

    sig { returns(Expression::Base) }
    attr_reader :expression
  end
end
