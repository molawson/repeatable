## CHANGELOG

### Unreleased

Chores:

* Add support for Ruby 3.2 and 3.3
* Deprecate support for Ruby 2.6, 2.7, and 3.0

[Commits](https://github.com/molawson/repeatable/compare/v1.2.0...main)

### 1.2.0 (2024-05-09)

Changes:

* Support pattern matching for `Expression` and `Schedule`
* Support more recent versions of sorbet

[Commits](https://github.com/molawson/repeatable/compare/v1.1.0...v1.2.0)

### 1.1.0 (2022-02-25)

Changes:

* Add [sorbet](https://sorbet.org) for type checking

Bug Fixes:

* Ensure `first_occurrence` is never part of `#to_h` output for `Expression::Biweekly`

Chores:

* Add support for Ruby 3.1
* Deprecate support for Ruby 2.5

[Commits](https://github.com/molawson/repeatable/compare/v1.0.0...v1.1.0)

### 1.0.0 (2021-03-25)

Breaking Changes:

* Change `Expression::DayInMonth` to take negative numbers instead of special `:last` symbol (or string)
* Stop including `Conversions` in top level namespace (must now be accessed via `Repeatable::Conversions::Date()` or by calling `include Repeatable::Conversions` in whatever namespace(s) it's needed)
* Require Ruby 2.5.0 or greater

Changes:

* Flatten nested `Expression::Union` elements during initialization ([@cmoel][])
* Flatten nested `Expression::Intersection` elements during initialization

Chores:

* Add support for Ruby 2.5, 2.6, 2.7, 3.0
* Introduce [standard](https://github.com/testdouble/standard) for code formatting

[Commits](https://github.com/molawson/repeatable/compare/v0.6.0...v1.0.0)


### 0.6.0 (2017-05-04)

Features:

* Add `Expression::Difference` for set differences between 2 schedules ([@danott][])
* Allow `Expression::DayInMonth` to take `:last` (or `'last'`) for its `day:` argument ([@PatrickLerner][])
* Allow `Expression::WeekdayInMonth` to take negative `count` argument for last, second-to-last, etc. of a given weekday ([@danielma][])

Bug Fixes:

* Fix `Expression::RangeInYear` to properly handle using `start_day` and `end_day` when `start_month == end_month` ([@danielma][])

[Commits](https://github.com/molawson/repeatable/compare/v0.5.0...v0.6.0)

### 0.5.0 (2016-01-27)

Features:

* Add `Expression::Biweekly` for "every other week" recurrence

[Commits](https://github.com/molawson/repeatable/compare/v0.4.0...v0.5.0)

### 0.4.0 (2015-06-29)

Features:

* Define equivalence `#==` for `Expression` and `Schedule` objects
* Define hash equality `#eql?` for `Expression::Date` objects
* Remove `ActiveSupport` dependency

[Commits](https://github.com/molawson/repeatable/compare/v0.3.0...v0.4.0)

### 0.3.0 (2015-03-11)

Features:

* Ensure `end_date` on or after `start_date` for `Schedule#occurrences` ([@danott][])
* Consider any invalid argument to `Schedule.new` a `ParseError` ([@danott][])

[Commits](https://github.com/molawson/repeatable/compare/v0.2.1...v0.3.0)

### 0.2.1 (2015-03-09)

Features:

* Add `ParseError` class for better error handling
* Extract `Parser` class from `Schedule`

Bug Fixes:

* Enable `Schedule` to take a hash with string keys

[Commits](https://github.com/molawson/repeatable/compare/v0.2.0...v0.2.1)

### 0.2.0 (2015-03-03)

Features:

* Add `Schedule#to_h` and `Expression#to_h` methods
* Enable building a `Schedule` from composed `Expression` objects

Bug Fixes:

* Fix default case equality for `Expression::Base` to work with classes and instances

[Commits](https://github.com/molawson/repeatable/compare/v0.1.0...v0.2.0)

### 0.1.0 (2015-02-23)

Initial Release

[Commits](https://github.com/molawson/repeatable/compare/531d40c...v0.1.0)


[@danott]: https://github.com/danott
[@PatrickLerner]: https://github.com/PatrickLerner
[@danielma]: https://github.com/danielma
[@cmoel]: https://github.com/cmoel
