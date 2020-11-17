# frozen_string_literal: true

module DX
  module Api
    module DataObjects
      # Describes data objects in bulk.
      # https://documentation.dnanexus.com/developer/api/system-methods#api-method-system-describedataobjects
      #
      #    DX::Api::DataObjects.describe(
      #      api_token: YOUR_API_TOKEN,
      #      objects: ["file-1234", "file-5678"]
      #    )
      #
      # @param api_token [String] Your DNAnexus api token.
      # @param objects [Array<String>] A list of data objects to describe.
      # @return [DX::Api::Response] The api response with return code and response body
      def self.describe(api_token:, objects:)
        api_path = %w[system describeDataObjects].join('/')

        DX::Api::Request.new(
          api_token: api_token,
          path: api_path,
          body: {
            objects: objects
          }
        ).make.then(&::DX::Api::Response.method(:from_http))
      end
    end
  end
end
