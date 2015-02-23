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

Describe a schedule with a Hash:

```ruby
args = {
  intersection: [                                     # All included conditions must be met
    weekday_in_month: { weekday: 1, count: 2 }        # The second Monday of every month
    range_in_year: { start_month: 10, end_month: 12 } # October through December
  ]
}

schedule = Repeatable::Schedule.new(args)
```

Ask your schedule one of three questions:

```ruby
schedule.next_occurrence
  # => Date of next occurrence

schedule.occurrences(Date.new(2015, 1, 1), Date.new(2016, 6, 30))
  # => Dates of all occurrences between Jan 1, 2015 and June 30, 2016

schedule.include?(Date.new(2015, 10, 10))
  # => Whether the schedule has an event on the date given (true/false)
```

Available time expressions:

```ruby
# Sets
union: []         # Any conditions can be met
intersection: []  # All conditions must be met

# Dates
weekday: { weekday: 0 }
  # Every Sunday
weekday_in_month: { weekday: 1, count: 3 }
  # The 3rd Monday of every month
day_in_month: { day: 13 }
  # The 13th of every month
range_in_year: { start_month: 10 }
  # Any day in October
range_in_year: { start_month: 10, end_month: 12 }
  # All days from October through December
range_in_year: { start_month: 10, end_month: 12, start_day: 1, end_day: 20 }
  # All days from October 1 through December 20
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
