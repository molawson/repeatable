module Repeatable
  module Expression
    class Set < Base
      def initialize(*elements)
        @elements = elements.flatten.uniq
      end

      def <<(element)
        elements << element unless elements.include?(element)
        self
      end

      def to_h
        Hash[self.class.name.demodulize.underscore.to_sym, elements.map(&:to_h)]
      end

      def ==(other)
        other.is_a?(self.class) &&
          elements.size == other.elements.size &&
          other.elements.all? { |e| elements.include?(e) }
      end

      protected

      attr_reader :elements
    end
  end
end
