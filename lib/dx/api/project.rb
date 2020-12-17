# frozen_string_literal: true

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
      # @raise [ResourceNotFoundError] if project specified by the id does not exist
      # @raise [InvalidAuthenticationError] if the supplied token could not authenticate againstthe dnanexus api
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
        ).make.then(&DX::Api::Response.method(:from_http))
      end

      # Clones one or more objects and/or folders from a source project into a destination project (and optionally into a destination folder).
      #
      # https://documentation.dnanexus.com/developer/api/data-containers/cloning#api-method-class-xxxx-clone
      #
      #    DX::Api::Project.clone(
      #      api_token: 'api_token',
      #      source_id: 'project-1234',
      #      destination_id: 'project-5678'
      #    )
      #    => #<DX::Api::Response:0x00007fcef41ca898 @body={"id"=>"project-1234", "project"=>"project-5678", "exists"=>[]}, @code=200>
      #
      # @param api_token [String] Your DNAnexus api token
      # @param source_id [String] The id of the source project to copy from
      # @param destination_id [String] The id of the destination project to copy to
      # @param source_folders [Array<String>] The source folders to copy
      # @param destination_folder [String] The destination folder
      # @param create_folders [Boolean] Whether the destination folder and/or parent folders should be created if they don't exist
      # @return [DX::Api::Response] A response object whose body, if the operation is successful, will contain the source, destination project id, and a list of object IDs that could not be cloned because they already exist in the destination project.
      def self.clone(api_token:, source_id:, destination_id:, source_folders: %w[/], destination_folder: '/', create_folders: true)
        path = [source_id, 'clone'].join('/')

        DX::Api::Request.new(
          api_token: api_token,
          path: path,
          body: {
            folders: source_folders,
            project: destination_id,
            destination: destination_folder,
            parents: create_folders
          }
        ).make.then(&DX::Api::Response.method(:from_http))
      end
    end
  end
end
