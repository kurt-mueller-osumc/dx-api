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
      # @return [DX::Api::Response::DescribedProject] The described project
      # @raise [ResourceNotFoundError] if project specified by the id does not exist
      # @raise [InvalidAuthenticationError] if the supplied token could not authenticate againstthe dnanexus api
      # InvalidInput
      def self.describe(api_token:, project_id:)
        DX::Api::Request.new(
          api_token: api_token,
          path: [project_id, 'describe'].join('/')
        ).make.then(&DX::Api::Response.method(:from_http))
              .then(&DX::Api::Project::Description.method(:from_response))
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
      # @return [String] The id of the newly created project
      # @raise [InvalidInputError] if project name is empty or invalid
      # @raise [InvalidStateError] if contains phi is true but project is not in a supported region
      # @raise [SpendingLimitExceededError] if the backing org has reached its spending limit
      # @raise [PermissionDeniedError] if permission is denied
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
              .then { |resp| resp.body.fetch('id') }
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

      # Clones one or more objects and/or folders from a source project into
      # a destination project (and optionally into a destination folder).
      #
      # https://documentation.dnanexus.com/developer/api/data-containers/cloning#api-method-class-xxxx-clone
      #
      # @param api_token [String] Your DNAnexus api token
      # @param source [DX::Api::Project::Source] The source project to copy from
      # @param destination [DX::Api::Project::Destination] The destination project to copy to
      # @return [DX::Api::Project::Clone] Info about the cloned project
      def self.clone(api_token:, source:, destination:)
        path = [source.id, 'clone'].join('/')

        DX::Api::Request.new(
          api_token: api_token,
          path: path,
          body: {
            folders: source.folders,
            project: destination.id,
            destination: destination.folder,
            parents: destination.create_folders
          }
        ).make.then(&DX::Api::Response.method(:from_http))
              .then(&Clone.method(:from_response))
      end

      class Source
        attr_reader :id, :folders

        # Initializes a source project to clone from.
        #
        # @param id [String] The id of the source project to copy from
        # @param folders [Array<String>] The source folders to copy
        def initialize(id:, folders: %w[/])
          @id = id
          @folders = folders
        end
      end

      class Destination
        attr_reader :id, :folder, :create

        # Initializes a destination project to clone to
        #
        # @param id [String] The id of the destination project to copy to
        # @param folder [String] The destination folder
        # @param create_folders [Boolean] If the destination and/or parent folders should be created if they don't exist
        def initialize(id:, folder: '/', create_folders: true)
          @id = id
          @folder = folder
          @create_folders = create_folders
        end
      end

      class Clone
        def self.from_response(resp)
          body = resp.body

          new(
            source_id: body.fetch('id'),
            destination_id: body.fetch('project'),
            existing_object_ids: body.fetch('exists')
          )
        end

        attr_reader :source_id, :destination_id, :existing_object_ids

        # A value object that represents that process of cloning from a source project into a
        # destination project.
        #
        # https://documentation.dnanexus.com/developer/api/data-containers/cloning
        #
        # @param source_id [String] The source project id
        # @param destination_id [String] The destination project id
        # @param existing_object_ids [Array<String>] Uncloned object IDs that already exist in the destination project
        def initialize(source_id:, destination_id:, existing_object_ids:)
          @source_id = source_id
          @destination_id = destination_id
          @existing_object_ids = existing_object_ids
        end
      end
    end
  end
end
