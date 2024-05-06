# typed: strict

module Repeatable
  module LastDateOfMonth
    extend T::Sig

    sig { params(date: ::Date).returns(::Date) }
    def last_date_of_month(date)
      ::Date.new(date.next_month.year, date.next_month.month, 1).prev_day
    end
  end
end
