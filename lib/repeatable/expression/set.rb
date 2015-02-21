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

      private

      attr_reader :elements
    end
  end
end
