# typed: strict
module Repeatable
  module Expression
    class Date < Base
      abstract!

      sig { params(other: Object).returns(T::Boolean) }
      def ==(other)
        other.is_a?(self.class) && attributes == other.attributes
      end
      alias_method :eql?, :==

      sig { returns(Integer) }
      def hash
        [attributes.values, self.class.name].hash
      end

      protected

      sig { returns(Types::SymbolHash) }
      def attributes
        instance_variables.each_with_object({}) do |name, hash|
          key = name.to_s.gsub(/^@/, "")
          next if key.start_with?("_")
          hash[key.to_sym] = normalize_attribute_value(instance_variable_get(name))
        end
      end
      alias_method :hash_value, :attributes

      sig { params(value: BasicObject).returns(T.untyped) }
      def normalize_attribute_value(value)
        case value
        when ::Date
          value.to_s
        else
          value
        end
      end
    end
  end
end
