module ScheduleArguments
  def simple_range_hash
    { range_in_year: { start_month: 10, end_month: 12 } }
  end

  def set_expression_hash
    {
      union: [
        { day_in_month: { day: 23 } },
        { range_in_year: { start_month: 10, end_month: 12 } }
      ]
    }
  end

  def stringified_set_expression_hash
    {
      'union' => [
        { 'day_in_month' => { 'day' => 23 } },
        { 'range_in_year' => { 'start_month' => 10, 'end_month' => 12 } }
      ]
    }
  end

  def nested_set_expression_hash
    {
      intersection: [
        {
          union: [
            { day_in_month: { day: 23 } },
            { day_in_month: { day: 24 } }
          ]
        },
        { range_in_year: { start_month: 10, end_month: 12 } }
      ]
    }
  end

  def nested_set_expression_object
    twenty_third = Repeatable::Expression::DayInMonth.new(day: 23)
    twenty_fourth = Repeatable::Expression::DayInMonth.new(day: 24)
    union = Repeatable::Expression::Union.new(twenty_third, twenty_fourth)
    oct_thru_dec = Repeatable::Expression::RangeInYear.new(start_month: 10, end_month: 12)

    Repeatable::Expression::Intersection.new(union, oct_thru_dec)
  end
end
