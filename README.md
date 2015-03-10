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

## Usage

### Building a Schedule

You can create a schedule in one of two ways.

#### Composed objects

Instantiate and compose each of the `Repeatable::Expression` objects manually.

```ruby
second_monday = Repeatabe::Expression::WeekdayInMonth.new(weekday: 1, count: 2)
oct_thru_dec = Repeatable::Expression::RangeInYear.new(start_month: 10, end_month: 12)
intersection = Repeatable::Expresson::Intersection.new(second_monday, oct_thru_dec)

schedule = Repeatable::Schedule.new(intersection)
```


#### Hash

Or describe the same structure with a `Hash`, and the gem will handle instantiating and composing the objects.

```ruby
arg = {
  intersection: [
    { weekday_in_month: { weekday: 1, count: 2 } },
    { range_in_year: { start_month: 10, end_month: 12 } }
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


# DATES

# Every Sunday
{ weekday: { weekday: 0 } }
Repeatable::Expression::Weekday.new(weekday: 0)

# The 3rd Monday of every month
{ weekday_in_month: { weekday: 1, count: 3 } }
Repeatable::Expression::WeekdayInMonth.new(weekday: 1, count: 3)

# The 13th of every month
{ day_in_month: { day: 13 } }
Repeatable::Expression::DayInMonth.new(day: 13)

# All days in October
{ range_in_year: { start_month: 10 } }
Repeatable::Expression::RangeInYear.new(start_month: 10)

# All days from October through December
{ range_in_year: { start_month: 10, end_month: 12 } }
Repeatable::Expression::RangeInYear.new(start_month: 10, end_month: 12)

# All days from October 1 through December 20
{ range_in_year: { start_month: 10, end_month: 12, start_day: 1, end_day: 20 } }
Repeatable::Expression::RangeInYear.new(start_month: 10, end_month: 12, start_day: 1, end_day: 20)
```

### Getting information from a Schedule

Ask a schedule to do a number of things.

```ruby
schedule.next_occurrence
  # => Date of next occurrence

schedule.occurrences(Date.new(2015, 1, 1), Date.new(2016, 6, 30))
  # => Dates of all occurrences between Jan 1, 2015 and June 30, 2016

schedule.include?(Date.new(2015, 10, 10))
  # => Whether the schedule has an event on the date given (true/false)

schedule.to_h
  # => Hash representation of the Schedule, which is useful for storage and
  #    can be used to recreate an identical Schedule object at a later time
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
