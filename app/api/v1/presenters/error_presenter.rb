module TA
  module API
    module V1
      module Presenters
        class ErrorPresenter
          DEFAULT_ERROR_CODE = 500

          attr_accessor :error, :code

          def initialize(error, code = nil)
            self.error = error
            self.code = (code || determine_code(error))
          end

          def present
            errors = messages.collect do |message|
              message.is_a?(Hash) ? present_hash_message(message) : present_string_message(message)
            end

            { errors: errors }
          end

          private

          def present_string_message(message)
            data = {
              code: code,
              description: description,
              message: message
            }
            data[:backtrace] = self.error.backtrace if self.error.respond_to?(:backtrace)
            data
          end

          def present_hash_message(message)
            symbolized_message = message.symbolize_keys
            string_message = symbolized_message.fetch(:message, symbolized_message.to_s)

            {
              code: code,
              description: description,
              message: string_message,
              data: symbolized_message.except(:message)
            }
          end

          def description
            error.class.name
          end

          def messages
            return error.messages if error.respond_to?(:messages)
            return [error.message] if error.respond_to?(:message)
            [error.to_s]
          end

          def determine_code(error)
            (error.respond_to?(:code)) ? error.code : DEFAULT_ERROR_CODE
          end
        end
      end
    end
  end
end
