module Repeatable
  class Parser
    def initialize(hash)
      @hash = hash
    end

    def self.call(hash)
      new(hash).call
    end

    def call
      build_expression(hash)
    end

    private

    attr_reader :hash

    def build_expression(hash)
      if hash.length != 1
        fail(ParseError, "Invalid expression: '#{hash}' must have single key and value")
      else
        expression_for(*hash.first)
      end
    end

    def expression_for(key, value)
      klass = "repeatable/expression/#{key}".classify.safe_constantize
      case klass
      when nil
        fail(ParseError, "Unknown mapping: Can't map key '#{key.inspect}' to an expression class")
      when Repeatable::Expression::Set
        args = value.map { |hash| build_expression(hash) }
        klass.new(*args)
      else
        klass.new(symbolize_keys(value))
      end
    end

    def symbolize_keys(hash)
      hash.each_with_object({}) { |(k, v), a| a[k.to_sym] = v }
    end
  end
end
