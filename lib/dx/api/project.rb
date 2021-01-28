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
      # @param api_token [String] Your DNAnexus api token
      # @param id [String] The project id
      # @param invitation [DX::Project::Invitation] A project invitation with the invitee's email/dnanexus id,
      #                                             permission level, email notification preference
      # @return [DX::Api::Project::InvitationReply] A reply that contains the invite id and the state of the invite
      # @raise [DX::Api::ResourceNotFoundError] if invitee is not a valid email address nor an DNAnexus user/org
      # @raise [DX::Api::InvalidInputError] if level is not provided OR level is not a valid permission level string
      # @raise [DX::Api::PermissionDeniedError] if caller doesn't have admin access to project
      def self.invite(api_token:, id:, invitation:)
        path = [id, 'invite'].join('/')

        DX::Api::Request.new(
          api_token: api_token,
          path: path,
          body: {
            invitee: invitation.invitee,
            level: invitation.level,
            suppressEmailNotification: !invitation.send_email
          }
        ).make.then(&DX::Api::Response.method(:from_http))
              .then(&InvitationReply.method(:from_resp))
      end

      # A response to an invitation to a project
      class InvitationReply
        def self.from_resp(resp)
          body = resp.body
          new(
            id: body.fetch('id'),
            state: body.fetch('state')
          )
        end

        attr_reader :id, :state

        def initialize(id:, state:)
          @id = id
          @state = state
        end
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
        body = CloneRequestBody.new(source, destination)

        DX::Api::Request.new(
          api_token: api_token,
          path: path,
          body: body.to_h.merge({parents: true})
        ).make.then(&DX::Api::Response.method(:from_http))
              .then(&Clone.method(:from_response))
      end


      # Searches for files within a project and, if specified, a specific folder, file names that match
      # a search phrase, and/or starting at a specific DNAnexus object id.
      #
      # https://documentation.dnanexus.com/developer/api/search#api-method-system-finddataobjects
      #
      # @param api_token [String] Your DNAnexus api token
      # @param project_id [String] The full id of the project
      # @param folder [String] The project folder to search in.
      # @parm with_name [String] A regular expression that any results must adhere to.
      # @param starting_at [String/NilClass] The file id to start at (optional)
      # @return [Array<DX::Api::ProjectFile::Description>] Descriptions of all project files.
      def self.find_files(api_token:, project_id:, folder: '/', with_name: nil, starting_at: nil)
        query = ::DX::Api::ProjectFile::Query.new(
          project_id: project_id,
          folder: folder,
          with_name: with_name,
          starting_at: starting_at
        )

        DX::Api::Request.new(
          api_token: api_token,
          path: %w[system findDataObjects].join('/'),
          body: query.to_h
        ).make
          .then(&::DX::Api::Response.method(:from_http))
          .then(&::DX::Api::ProjectFile::SearchResult.method(:from_resp))
      end

      # Searches for all files within a project, recursively. If the response indicates another
      # page exists, it queries for the next page of files. Search results are yielded to a block,
      # if present.
      #
      # https://documentation.dnanexus.com/developer/api/search#api-method-system-finddataobjects
      #
      #    DX::Api::Project.find_all_files(
      #      api_token: YOUR_API_TOKEN,
      #      project_id: "project-1234"
      #    ) do |project_files|
      #      pp project_files
      #    end
      #
      # @param api_token [String] Your DNAnexus api token
      # @param project_id [String] The full id of the project
      # @param folder [String] The project folder to search in.
      # @parm with_name [String] A regular expression that any results must adhere to.
      # @param starting_at [String/NilClass] The file id to start at (optional)
      # @return [Array<DX::Api::ProjectFile::Description>] Descriptions of all project files.
      def self.find_all_files(api_token:, project_id:, folder: '/', with_name: nil, starting_at: nil, &block)
        search_result = find_files(
          api_token: api_token,
          project_id: project_id,
          folder: folder,
          with_name: with_name,
          starting_at: starting_at
        )

        project_files = search_result.project_files

        block&.call(project_files)

        if search_result.no_more_files?
          project_files
        else
          next_file_id = search_result.next_file_id

          project_files.concat(
            find_all_files(
              api_token: api_token,
              project_id: project_id,
              starting_at: next_file_id, &block
            )
          )
        end
      end

      # The source object to clone from
      class Source
        attr_reader :id, :folders, :object_ids

        # Initializes a source project to clone from.
        #
        # @param id [String] The id of the source project to copy from
        # @param folders [Array<String>] The source folders to copy
        # @param object_ids [Array<String>] Object ids to compy from the project
        def initialize(id:, folders: %w[/], object_ids: [])
          @id = id
          @folders = folders
          @object_ids = object_ids
        end

        def has_folders?
          folders.reject { |folder| folder == '/' }.any?
        end

        def has_object_ids?
          object_ids.any?
        end
      end

      # The destination object copy to
      class Destination
        attr_reader :id, :folder

        # Initializes a destination project to clone to
        #
        # @param id [String] The id of the destination project to copy to
        # @param folder [String] The destination folder
        def initialize(id:, folder: '/')
          @id = id
          @folder = folder
        end

        def root_folder?
          folder == '/'
        end
      end

      # Helper methods to create a request body from a source and destination
      CloneRequestBody = Struct.new(:source, :destination) do
        def to_h
          {}.tap do |body|
            body[:objects] = source.object_ids if source.has_object_ids?
            body[:folders] = source.folders if source.has_folders?
            body[:project] = destination.id
            body[:destination] = destination.folder unless destination.root_folder?
          end
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
