# typed: strong
module Repeatable
  VERSION = "1.2.0"

  module Conversions
    extend T::Sig

    sig { params(arg: Object).returns(::Date) }
    def Date(arg); end
  end

  module LastDateOfMonth
    extend T::Sig

    sig { params(date: ::Date).returns(::Date) }
    def last_date_of_month(date); end
  end

  class ParseError < StandardError
  end

  class Parser
    extend T::Sig

    sig { params(hash: T::Hash[T.any(String, Symbol), T.untyped]).void }
    def initialize(hash); end

    sig { params(hash: T::Hash[T.any(String, Symbol), T.untyped]).returns(Expression::Base) }
    def self.call(hash); end

    sig { returns(Expression::Base) }
    def call; end

    sig { returns(T.untyped) }
    attr_reader :hash

    sig { params(hash: T.untyped).returns(T.untyped) }
    def build_expression(hash); end

    sig { params(key: T.untyped, value: T.untyped).returns(T.untyped) }
    def expression_for(key, value); end

    sig { params(hash: T.untyped).returns(T.untyped) }
    def symbolize_keys(hash); end

    sig { params(string: T.untyped).returns(T.untyped) }
    def expression_klass(string); end
  end

  class Schedule
    extend T::Sig

    sig { params(arg: Object).void }
    def initialize(arg); end

    sig { params(start_date: Object, end_date: Object).returns(T::Array[::Date]) }
    def occurrences(start_date, end_date); end

    sig { params(start_date: Object, include_start: T::Boolean, limit: Integer).returns(T.nilable(::Date)) }
    def next_occurrence(start_date = Date.today, include_start: false, limit: 36525); end

    sig { params(date: Object).returns(T::Boolean) }
    def include?(date = Date.today); end

    sig { returns(T::Hash[Symbol, T.any(Types::SymbolHash, T::Array[Types::SymbolHash])]) }
    def to_h; end

    sig { params(_keys: T.nilable(T::Array[Symbol])).returns(T::Hash[Symbol, T.any(Types::SymbolHash, T::Array[Types::SymbolHash])]) }
    def deconstruct_keys(_keys); end

    sig { params(other: Object).returns(T::Boolean) }
    def ==(other); end

    sig { returns(Expression::Base) }
    attr_reader :expression
  end

  module Types
    SymbolHash = T.type_alias { T::Hash[Symbol, T.untyped] }
  end

  module Expression
    class Base
      abstract!

      extend T::Sig
      extend T::Helpers

      sig { params(other: Object).returns(T::Boolean) }
      def self.===(other); end

      sig { abstract.params(date: ::Date).returns(T::Boolean) }
      def include?(date); end

      sig { returns(T::Hash[Symbol, T.any(Types::SymbolHash, T::Array[Types::SymbolHash])]) }
      def to_h; end

      sig { params(_keys: T.nilable(T::Array[Symbol])).returns(T::Hash[Symbol, T.any(Types::SymbolHash, T::Array[Types::SymbolHash])]) }
      def deconstruct_keys(_keys); end

      sig { params(other: Expression::Base).returns(Expression::Union) }
      def union(other); end

      sig { params(other: Expression::Base).returns(Expression::Intersection) }
      def intersection(other); end

      sig { params(other: T.untyped).returns(Expression::Difference) }
      def difference(other); end

      sig { returns(Symbol) }
      def hash_key; end

      sig { abstract.returns(T.any(Types::SymbolHash, T::Array[Types::SymbolHash])) }
      def hash_value; end
    end

    class Biweekly < Date
      sig { params(weekday: Integer, start_after: Object).void }
      def initialize(weekday:, start_after: ::Date.today); end

      sig { override.params(date: ::Date).returns(T::Boolean) }
      def include?(date); end

      sig { returns(Integer) }
      attr_reader :weekday

      sig { returns(::Date) }
      attr_reader :start_after

      sig { returns(::Date) }
      attr_reader :_first_occurrence

      sig { returns(::Date) }
      def find_first_occurrence; end
    end

    class Date < Base
      abstract!

      sig { params(other: Object).returns(T::Boolean) }
      def ==(other); end

      sig { returns(Integer) }
      def hash; end

      sig { returns(Types::SymbolHash) }
      def attributes; end

      sig { params(value: BasicObject).returns(T.untyped) }
      def normalize_attribute_value(value); end
    end

    class DayInMonth < Date
      include LastDateOfMonth

      sig { params(day: Integer).void }
      def initialize(day:); end

      sig { override.params(date: ::Date).returns(T::Boolean) }
      def include?(date); end

      sig { returns(Integer) }
      attr_reader :day
    end

    class Difference < Base
      sig { params(included: Expression::Base, excluded: Expression::Base).void }
      def initialize(included:, excluded:); end

      sig { override.params(date: ::Date).returns(T::Boolean) }
      def include?(date); end

      sig { params(other: Object).returns(T::Boolean) }
      def ==(other); end

      sig { returns(Expression::Base) }
      attr_reader :included

      sig { returns(Expression::Base) }
      attr_reader :excluded

      sig { override.returns(Types::SymbolHash) }
      def hash_value; end
    end

    class ExactDate < Date
      sig { params(date: Object).void }
      def initialize(date:); end

      sig { override.params(other_date: ::Date).returns(T::Boolean) }
      def include?(other_date); end

      sig { returns(::Date) }
      attr_reader :date
    end

    class Intersection < Set
      sig { params(elements: T.any(Expression::Base, T::Array[Expression::Base])).void }
      def initialize(*elements); end

      sig { override.params(date: ::Date).returns(T::Boolean) }
      def include?(date); end
    end

    class RangeInYear < Date
      sig do
        params(
          start_month: Integer,
          end_month: Integer,
          start_day: Integer,
          end_day: Integer
        ).void
      end
      def initialize(start_month:, end_month: start_month, start_day: 0, end_day: 0); end

      sig { override.params(date: ::Date).returns(T::Boolean) }
      def include?(date); end

      sig { returns(Integer) }
      attr_reader :start_month

      sig { returns(Integer) }
      attr_reader :end_month

      sig { returns(Integer) }
      attr_reader :start_day

      sig { returns(Integer) }
      attr_reader :end_day

      sig { params(date: ::Date).returns(T::Boolean) }
      def months_include?(date); end

      sig { params(date: ::Date).returns(T::Boolean) }
      def start_month_include?(date); end

      sig { params(date: ::Date).returns(T::Boolean) }
      def end_month_include?(date); end

      sig { override.returns(T::Hash[Symbol, Integer]) }
      def hash_value; end
    end

    class Set < Base
      abstract!

      sig { returns(T::Array[Expression::Base]) }
      attr_reader :elements

      sig { params(elements: T::Array[Expression::Base]).void }
      def initialize(elements); end

      sig { params(element: T.untyped).returns(Repeatable::Expression::Set) }
      def <<(element); end

      sig { params(other: Object).returns(T::Boolean) }
      def ==(other); end

      sig { override.returns(T::Array[Types::SymbolHash]) }
      def hash_value; end
    end

    class Union < Set
      sig { params(elements: T.any(Expression::Base, T::Array[Expression::Base])).void }
      def initialize(*elements); end

      sig { override.params(date: ::Date).returns(T::Boolean) }
      def include?(date); end
    end

    class Weekday < Date
      sig { params(weekday: Integer).void }
      def initialize(weekday:); end

      sig { override.params(date: ::Date).returns(T::Boolean) }
      def include?(date); end

      sig { returns(Integer) }
      attr_reader :weekday
    end

    class WeekdayInMonth < Date
      include LastDateOfMonth

      sig { params(weekday: Integer, count: Integer).void }
      def initialize(weekday:, count:); end

      sig { override.params(date: ::Date).returns(T::Boolean) }
      def include?(date); end

      sig { returns(Integer) }
      attr_reader :weekday

      sig { returns(Integer) }
      attr_reader :count

      sig { params(date: ::Date).returns(T::Boolean) }
      def day_matches?(date); end

      sig { params(date: ::Date).returns(T::Boolean) }
      def week_matches?(date); end

      sig { params(date: ::Date).returns(Integer) }
      def week_from_beginning(date); end

      sig { params(date: ::Date).returns(Integer) }
      def week_from_end(date); end

      sig { params(zero_indexed_day: Integer).returns(Integer) }
      def week_in_month(zero_indexed_day); end

      sig { returns(T::Boolean) }
      def negative_count?; end
    end
  end
end
