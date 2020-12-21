module DX
  module Api
    module ProjectFile
      # A description of a file in project. Note that this is differen than just
      # a file object itself, which can be contained in multiple projects, with
      # multiple folder paths and file names.
      class Description
        def self.from_search_result(result_body)
          describe = result_body.fetch('describe')

          new(
            project_id: result_body.fetch('project'),
            id: result_body.fetch('id'),
            name: describe.fetch('name'),
            state: describe.fetch('state'),
            folder: describe.fetch('folder'),
            archival_state: describe.fetch('archivalState'),
            media: describe.fetch('media')
          )
        end

        attr_reader :project_id, :id, :name, :state, :folder, :archival_state, :media

        # A project file description.
        # https://documentation.dnanexus.com/developer/api/introduction-to-data-object-classes/files#api-method-file-xxxx-describe
        #
        # @param project_id [String] The file's project id
        # @param id [String] The file id
        # @param name [String] The file name
        # @param folder [String] The full path to the folder containing the file
        # @param state [String] The value "open", "closing", or "closed"
        # @param archival_state [String] The archival state of the file
        # @param media [String] The Internet Media Type of the file
        def initialize(project_id:, id:, name:, folder:, state:, archival_state:, media:)
          @project_id = project_id
          @id = id
          @name = name
          @folder = folder
          @archival_state = archival_state
          @media = media
        end
      end
    end
  end
end
