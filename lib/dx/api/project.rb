module DX
  module Api
    # Access the DNAnexus project api.
    # https://documentation.dnanexus.com/developer/api/data-containers/projects
    module Project
      # Describe the specified project
      # https://documentation.dnanexus.com/developer/api/data-containers/projects#api-method-project-xxxx-describe
      #
      #    DX::Api::Project.describe(
      #      api_token: "api_token",
      #      project_id:"project-1234"
      #    )
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
      #    DX::Api::Project.create(
      #      api_token: "api_token",
      #      name: "Project name",
      #      summary: "Project summary"
      #    )
      #
      # @param api_token [String] Your DNAnexus api token
      # @param name [String] The project name
      # @param summary [String] The project summary
      # @param bill_to [String] The entity id which any costs associated with this project will be billed
      # @return [DX::Api::Response] A response object whose body will contain the project's id.
      def self.create(api_token:, name:, summary:, bill_to:)
        DX::Api::Request.new(
          api_token: api_token,
          path: %w[project new].join('/'),
          body: {
            name: name,
            summary: summary,
            description: summary,
            billTo: bill_to
          }
        ).make.then(&DX::Api::Response.method(:from_http))
      end

      # Invites a DNAnexus user or org to the project at the specified permission level. An email address
      # can be used to specify the invitee in the case of a user invitee. If the invitee already has access
      # to the project but at a lower permission level than the one specified, then the permission level of
      # the invitee will be upgraded to the specified permission level.
      #
      # https://documentation.dnanexus.com/developer/api/data-containers/project-permissions-and-sharing#api-method-project-xxxx-invite
      #
      #    DX::Api::Project.invite(
      #      api_token: 'api_token',
      #      id: 'project-1234',
      #      invitee: 'arthur.james@osumc.edu',
      #      level: 'VIEWER'
      #    )
      #
      # @param api_token [String] Your DNAnexus api token
      # @param id [String] The project id
      # @param invitee [String] An email address of a current DNAnexus user or a DNAnexus id
      # @param level [String] A permission level; must be one of "VIEW", "UPLOAD", "CONTRIBUTE", or "ADMINISTER"
      # @param send_email_notification [Boolean] If true, send an email notification to the invitee
      # @return [DX::Api::Response] A response object whose body will contain the invitation status
      def self.invite(api_token:, id:, invitee:, level:, send_email_notification: true)
        path = [id, 'invite'].join('/')

        DX::Api::Request.new(
          api_token: api_token,
          path: path,
          body: {
            invitee: invitee,
            level: level,
            suppressEmailNotification: !send_email_notification
          }
        )
      end
    end
  end
end
