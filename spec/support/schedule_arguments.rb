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

  def reordered_nested_set_expression_hash
    {
      intersection: [
        { range_in_year: { start_month: 10, end_month: 12 } },
        {
          union: [
            { day_in_month: { day: 24 } },
            { day_in_month: { day: 23 } }
          ]
        }
      ]
    }
  end

  def difference_expression_hash
    {
      difference: {
        included: { weekday: { weekday: 1 } },
        excluded: {
          union: [
            { day_in_month: { day: 4} },
            { day_in_month: { day: 11} },
          ]
        }
      }
    }
  end

  def difference_expression_object
    mondays = Repeatable::Expression::Weekday.new(weekday: 1)
    fourths = Repeatable::Expression::DayInMonth.new(day: 4)
    elevenths = Repeatable::Expression::DayInMonth.new(day: 11)
    union = Repeatable::Expression::Union.new(fourths, elevenths)

    Repeatable::Expression::Difference.new(included: mondays, excluded: union)
  end

  def nested_set_expression_object
    twenty_third = Repeatable::Expression::DayInMonth.new(day: 23)
    twenty_fourth = Repeatable::Expression::DayInMonth.new(day: 24)
    union = Repeatable::Expression::Union.new(twenty_third, twenty_fourth)
    oct_thru_dec = Repeatable::Expression::RangeInYear.new(start_month: 10, end_month: 12)

    Repeatable::Expression::Intersection.new(union, oct_thru_dec)
  end
end
