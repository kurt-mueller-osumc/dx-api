require 'net/http'
require 'json'

module DX
  module Api
    module Project
      # Describe the specified project
      # https://documentation.dnanexus.com/developer/api/data-containers/projects#api-method-project-xxxx-describe
      #
      # @param api_token [String] Your DNAnexus api token.
      # @param project_id [String] The full id of the project.
      # @return [Hash] A hash that contains the response code and json-parsed body
      def self.describe(api_token:, project_id:)
        uri = [DX::Api::HOST_NAME, project_id, 'describe'].join('/').then { |url| URI(url) }

        Net::HTTP.post(
          uri,
          {}.to_json,
          'Content-Type' => 'application/json',
          'Authorization' => "Bearer #{api_token}"
        ).then do |resp|
          {
            code: resp.code.to_i,
            body: resp.body.then(&JSON.method(:parse))
          }
        end
      end

      def self.create(api_token:); end
    end
  end
end
