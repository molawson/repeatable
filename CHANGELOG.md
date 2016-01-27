## CHANGELOG

### Unreleased

[Commits](https://github.com/molawson/repeatable/compare/v0.5.0...master)

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

Bugfixes:

* Enable `Schedule` to take a hash with string keys

[Commits](https://github.com/molawson/repeatable/compare/v0.2.0...v0.2.1)

### 0.2.0 (2015-03-03)

Features:

* Add `Schedule#to_h` and `Expression#to_h` methods
* Enable building a `Schedule` from composed `Expression` objects

Bugfixes:

* Fix default case equality for `Expression::Base` to work with classes and instances

[Commits](https://github.com/molawson/repeatable/compare/v0.1.0...v0.2.0)

### 0.1.0 (2015-02-23)

Initial Release

[Commits](https://github.com/molawson/repeatable/compare/531d40c...v0.1.0)


[@danott]: https://github.com/danott
