require 'forwardable'
require 'net/http'
require 'json'

module DX
  module Api
    # A helper class to create and make http requests to the DNAnexus API
    class Request
      HOST_NAME = 'https://api.dnanexus.com'.freeze

      extend Forwardable

      attr_reader :api_token,
                  :uri,
                  :body

      def_delegators :uri, :hostname, :port

      # Creates a request to be made to the DNAnexus API
      #
      # @param api_token [String] Your API token
      # @param url [String] The API path
      # @param body [Hash] The request payload
      def initialize(api_token:, path:, body: {})
        @api_token = api_token
        @uri = URI([HOST_NAME, path].join('/'))
        @body = body.to_json
      end

      # Convert the DNAnexus API request to a Net::HTTP request
      #
      # @returns [Net::HTTP::Post] A POST request to be made to the DX api
      def to_http
        Net::HTTP::Post.new(uri).tap do |req|
          req['Content-Type']  = 'application/json'
          req['Authorization'] = "Bearer #{api_token}"
          req.body = body
        end
      end

      def make
        Net::HTTP.start(hostname, port, use_ssl: true) do |http|
          http.request(to_http)
        end
      end
    end
  end
end
