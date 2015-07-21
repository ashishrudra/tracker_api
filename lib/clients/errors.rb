module Clients
  module Errors
    class Base < StandardError
      MESSAGE = "Remote Error"

      attr_accessor :response

      def initialize(response)
        self.response = response
      end

      def to_s
        message.to_s
      end

      def message
        {
          method: request.options[:method],
          url: request.base_url,
          code: response.code,
          body: response.body,
          message: MESSAGE
        }
      end

      def request
        response.request
      end
    end

    class Response < Base
      CODE = 502

      def code
        CODE
      end
    end

    class Timeout < Base
      CODE = 504

      def code
        CODE
      end
    end
  end
end
