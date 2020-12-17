# frozen_string_literal: true

require 'json'

module DX
  module Api
    class Response
      def self.from_http(http_response)
        new(code: http_response.code, body: http_response.body)
      end

      attr_reader :code,
                  :body

      def initialize(code:, body:)
        @code = code.to_i
        @body = body.is_a?(String) ? JSON.parse(body) : body

        if @body.key?('error')
          error = @body.fetch('error')
          ErrorHandler.new(
            type: error.fetch('type'),
            message: error.fetch('message'),
            code: code
          ).raise!
        end
      end

      def to_h
        {
          code: resp.code,
          body: resp.body
        }
      end
    end
  end
end
