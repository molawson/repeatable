module Repeatable
  module Expression
    class Set < Base
      def initialize(*elements)
        @elements = elements.flatten
      end

      def <<(element)
        elements << element
        self
      end

      def to_h
        hash = {}
        hash[self.class.name.demodulize.underscore.to_sym] = elements.map(&:to_h)
        hash
      end

      private

      attr_reader :elements
    end
  end
end
