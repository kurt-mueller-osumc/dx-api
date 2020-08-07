module DX
  module Api
    # Access the DNAnexus project api.
    # https://documentation.dnanexus.com/developer/api/data-containers/projects
    module Project
      # Describe the specified project
      # https://documentation.dnanexus.com/developer/api/data-containers/projects#api-method-project-xxxx-describe
      #
      # DX::Api::Project.describe(
      #   api_token: "api_token",
      #   project_id:"project-1234"
      # )
      #
      # @param api_token [String] Your DNAnexus api token
      # @param project_id [String] The full id of the project
      # @return [DX::Api::Response] A response object that contains the response code and json-parsed body
      def self.describe(api_token:, project_id:)
        DX::Api::Request.new(
          api_token: api_token,
          path: [project_id, 'describe'].join('/')
        ).make.then(&DX::Api::Response.method(:from_http))
      end

      # Create a new project
      # https://documentation.dnanexus.com/developer/api/data-containers/projects#api-method-project-new
      #
      # DX::Api::Project.create(
      #   api_token: "api_token",
      #   name: "Project name",
      #   summary: "Project summary"
      # )
      #
      # @param api_token [String] Your DNAnexus api token
      # @param name [String] The project name
      # @param summary [String] The project summary
      # @return [Hash] A hash that contains the response code and the id of created project
      def self.create(api_token:, name:, summary:)
        DX::Api::Request.new(
          api_token: api_token,
          path: %w[project new].join('/'),
          body: {
            name: name,
            summary: summary,
            description: summary
          }
        ).make.then(&DX::Api::Response.method(:from_http))
      end
    end
  end
end
