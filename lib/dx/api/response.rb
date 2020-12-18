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

        ::DX::Api::ErrorHandler.from_response(self).raise! if @body.key?('error')
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
