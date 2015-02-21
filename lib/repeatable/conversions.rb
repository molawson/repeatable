module Repeatable
  module Conversions
    module_function

    def Date(arg)
      case arg
      when Date, Time
        arg.to_date
      else
        Date.parse(arg)
      end
    rescue ArgumentError
      raise TypeError, "Cannot convert #{arg.inspect} to Date"
    end
  end
end
