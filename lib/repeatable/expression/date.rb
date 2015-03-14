module Repeatable
  module Expression
    class Date < Base

      def to_h
        Hash[self.class.name.demodulize.underscore.to_sym, attributes]
      end

      def ==(other)
        other.is_a?(self.class) && attributes == other.attributes
      end

      protected

      def attributes
        Hash[instance_variables.map { |name| [name[1..-1].to_sym, instance_variable_get(name)] }]
      end
    end
  end
end
