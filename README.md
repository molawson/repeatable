# Repeatable

[![CI](https://github.com/molawson/repeatable/actions/workflows/ci.yml/badge.svg)](https://github.com/molawson/repeatable/actions/workflows/ci.yml)
[![Maintainability](https://api.codeclimate.com/v1/badges/73707efd5eeffd364c0d/maintainability)](https://codeclimate.com/github/molawson/repeatable/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/73707efd5eeffd364c0d/test_coverage)](https://codeclimate.com/github/molawson/repeatable/test_coverage)

Ruby implementation of Martin Fowler's [Recurring Events for Calendars](http://martinfowler.com/apsupp/recurring.pdf) paper.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'repeatable'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install repeatable

## Usage

### Building a Schedule

You can create a schedule in one of two ways.

#### Composed objects

Instantiate and compose each of the `Repeatable::Expression` objects manually.

```ruby
second_monday = Repeatable::Expression::WeekdayInMonth.new(weekday: 1, count: 2)
oct_thru_dec = Repeatable::Expression::RangeInYear.new(start_month: 10, end_month: 12)
intersection = Repeatable::Expression::Intersection.new(second_monday, oct_thru_dec)

schedule = Repeatable::Schedule.new(intersection)
```


#### Hash

Or describe the same structure with a `Hash`, and the gem will handle instantiating and composing the objects.

```ruby
arg = {
  intersection: [
    { weekday_in_month: { weekday: 1, count: 2 } },
    { range_in_year: { start_month: 10, end_month: 12 } },
    { exact_date: { date: "2015-08-01" } }
  ]
}

schedule = Repeatable::Schedule.new(arg)
```

- - -

#### Time Expressions

There are a number of time expressions available which, when combined, can describe most any schedule.

```ruby
# SETS

# Any conditions can be met
{ union: [] }
Repeatable::Expression::Union.new(expressions)

# All conditions must be met
{ intersection: [] }
Repeatable::Expression::Intersection.new(expressions)

# Date is part of the first set (`included`) but not part of the second set (`excluded`)
{ difference: { included: expression, excluded: another_expression } }
Repeatable::Expression::Difference.new(included: expression, excluded: another_expression)


# DATES

# Every Sunday
{ weekday: { weekday: 0 } }
Repeatable::Expression::Weekday.new(weekday: 0)

# The 3rd Monday of every month
{ weekday_in_month: { weekday: 1, count: 3 } }
Repeatable::Expression::WeekdayInMonth.new(weekday: 1, count: 3)

# The last Thursday of every month
{ weekday_in_month: { weekday: 4, count: -1 } }
Repeatable::Expression::WeekdayInMonth.new(weekday: 4, count: -1)

# Every other Monday, starting from December 1, 2015
{ biweekly: { weekday: 1, start_after: '2015-12-01' } }
Repeatable::Expression::Biweekly.new(weekday: 1, start_after: Date.new(2015, 12, 1))

# The 13th of every month
{ day_in_month: { day: 13 } }
Repeatable::Expression::DayInMonth.new(day: 13)

# The last day of every month
{ day_in_month: { day: -1 } }
Repeatable::Expression::DayInMonth.new(day: -1)

# All days in October
{ range_in_year: { start_month: 10 } }
Repeatable::Expression::RangeInYear.new(start_month: 10)

# All days from October through December
{ range_in_year: { start_month: 10, end_month: 12 } }
Repeatable::Expression::RangeInYear.new(start_month: 10, end_month: 12)

# All days from October 1 through December 20
{ range_in_year: { start_month: 10, end_month: 12, start_day: 1, end_day: 20 } }
Repeatable::Expression::RangeInYear.new(start_month: 10, end_month: 12, start_day: 1, end_day: 20)

# only December 21, 2012
{ exact_date: { date: '2012-12-21' } }
Repeatable::Expression::ExactDate.new(date: Date.new(2012, 12, 21)
```

#### Schedule Errors

If something in the argument passed into `Repeatable::Schedule.new` can't be handled by the `Schedule` or `Parser` (e.g. an expression hash key that doesn't match an existing expression class), a `Repeatable::ParseError` will be raised with a (hopefully) helpful error message.

### Getting information from a Schedule

Ask a schedule to do a number of things.

```ruby
schedule.next_occurrence
  # => Date of next occurrence

# By default, it will find the next occurrence after Date.today.
# You can also specify a start date.
schedule.next_occurrence(Date.new(2015, 1, 1))
  # => Date of next occurrence after Jan 1, 2015

# You also have the option of including the start date as a possible result.
schedule.next_occurrence(Date.new(2015, 1, 1), include_start: true)
  # => Date of next occurrence on or after Jan 1, 2015

# By default, searches for the next occurrence are limited to the next 36,525 days (about 100 years).
# That limit can also be specified in number of days.
schedule.next_occurrence(limit: 365)
  # => Date of next occurrence within the next 365 days

schedule.occurrences(Date.new(2015, 1, 1), Date.new(2016, 6, 30))
  # => Dates of all occurrences between Jan 1, 2015 and June 30, 2016

schedule.include?(Date.new(2015, 10, 10))
  # => Whether the schedule has an event on the date given (true/false)

schedule.to_h
  # => Hash representation of the Schedule, which is useful for storage and
  #    can be used to recreate an identical Schedule object at a later time
```

#### Pattern Matching

Both `Repeatable::Schedule` and all `Repeatable::Expression` classes support Ruby 2.7+ [pattern matching][ruby-pattern-matching] which is particularly useful for parsing or presenting an existing schedule.

```ruby
case schedule
in weekday: { weekday: }
  "Weekly on #{Date::DAYNAMES[weekday]}"
in day_in_month: { day: }
  "Every month on the #{day.ordinalize}"
in weekday_in_month: { weekday:, count: }
  "Every month on the #{count.ordinalize} #{Date::DAYNAMES[weekday]}"
end
```

#### Equivalence

Both `Repeatable::Schedule` and all `Repeatable::Expression` classes have equivalence `#==` defined according to what's appropriate for each class, so regardless of the order of arguments passed to each, you can tell whether one object is equivalent to the other in terms of whether or not, when asked the same questions, you'd receive the same results from each.

```ruby
Repeatable::Expression::DayInMonth.new(day: 1) == Repeatable::Expression::DayInMonth.new(day: 1)
  # => true

first = Repeatable::Expression::DayInMonth.new(day: 1)
fifteenth = Repeatable::Expression::DayInMonth.new(day: 15)
first == fifteenth
  # => false

union = Repeatable::Expression::Union.new(first, fifteenth)
another_union = Repeatable::Expression::Union.new(fifteenth, first)
union == another_union
  # => true (order of Union and Intersection arguments doesn't their affect output)

Repeatable::Schedule.new(union) == Repeatable::Schedule.new(another_union)
  # => true (their expressions are equivalent, so they'll produce the same results)

```

## Ruby version support

Currently tested and supported: 
- 3.2
- 3.3
- 3.4

Deprecated (currently tested but have reached EOL and will be unsupported in the next major version):
- 2.5
- 2.6
- 2.7
- 3.0
- 3.1

The supported versions will roughly track with versions that are currently maintained by the Ruby core team.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

You can run the tests with `bundle exec rake`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/molawson/repeatable. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

1. Fork it ( https://github.com/molawson/repeatable/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Repeatable project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/molawson/repeatable/blob/main/CODE_OF_CONDUCT.md).

[ruby-pattern-matching]: https://docs.ruby-lang.org/en/3.0/syntax/pattern_matching_rdoc.html
