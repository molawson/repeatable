module Repeatable
  module Expression
    class Date < Base
      def to_h
        Hash[hash_key, attributes]
      end

      def ==(other)
        other.is_a?(self.class) && attributes == other.attributes
      end

      alias_method :eql?, :==

      def hash
        [attributes.values, self.class.name].hash
      end

      protected

      def attributes
        instance_variables.each_with_object({}) do |name, hash|
          key = name.to_s.gsub(/^@/, "").to_sym
          hash[key] = normalize_attribute_value(instance_variable_get(name))
        end
      end

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
