# typed: strict
module Repeatable
  module Conversions
    extend T::Sig

    module_function

    sig { params(arg: Object).returns(::Date) }
    def Date(arg)
      case arg
      when Date, Time
        arg.to_date
      else
        Date.parse(arg)
      end
    rescue ArgumentError
      Kernel.raise TypeError, "Cannot convert #{arg.inspect} to Date"
    end
  end
end
