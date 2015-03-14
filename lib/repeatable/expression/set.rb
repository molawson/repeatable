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

      private

      attr_reader :elements
    end
  end
end
