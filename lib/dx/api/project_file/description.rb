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
            archival_state: describe.fetch('archivalState')
          )
        end

        attr_reader :project_id, :id, :name, :state, :folder, :archival_state

        def initialize(project_id:, id:, name:, state:, folder:, archival_state:)
          @project_id = project_id
          @id = id
          @name = name
          @folder = folder
          @archival_state = archival_state
        end
      end
    end
  end
end
