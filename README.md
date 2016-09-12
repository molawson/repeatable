# Repeatable

[![Build Status](https://img.shields.io/travis/molawson/repeatable.svg)](https://travis-ci.org/molawson/repeatable)
[![Code Climate](https://img.shields.io/codeclimate/github/molawson/repeatable.svg)](https://codeclimate.com/github/molawson/repeatable)
[![Code Climate Coverage](https://img.shields.io/codeclimate/coverage/github/molawson/repeatable.svg)](https://codeclimate.com/github/molawson/repeatable)

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

## Requirements

Because this gem relies heavily on required keyword arguments, especially to make dumping and parsing of schedules simpler, this code will only work on **Ruby 2.1** and higher.

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

# Every other Monday, starting from December 1, 2015
{ biweekly: { weekday: 1, start_date: '2015-12-01' } }
Repeatable::Expression::Biweekly.new(weekday: 1, start_date: Date.new(2015, 12, 1))

# The 13th of every month
{ day_in_month: { day: 13 } }
Repeatable::Expression::DayInMonth.new(day: 13)

# The last day of every month
{ day_in_month: { day: :last } }
Repeatable::Expression::DayInMonth.new(day: :last)

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

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/molawson/repeatable/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
