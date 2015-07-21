module GG
  module Errors
    class InvalidCondition < StandardError
      CODE = 400

      attr_accessor :condition

      def initialize(condition)
        self.condition = condition
      end

      def to_s
        condition
      end

      def code
        CODE
      end
    end
  end
end
