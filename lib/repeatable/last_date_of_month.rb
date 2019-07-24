# typed: true
module Repeatable
  module LastDateOfMonth
    def last_date_of_month(date)
      ::Date.new(date.next_month.year, date.next_month.month, 1).prev_day
    end
  end
end
