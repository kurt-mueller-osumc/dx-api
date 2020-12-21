module DX
  module Api
    module ProjectFile
      class SearchResult
        def self.from_resp(resp)
          body = resp.body

          new(
            project_files: body.fetch('results').map(&::DX::Api::ProjectFile::Description.method(:from_search_result)),
            next_file_id: body.dig('next', 'id')
          )
        end

        attr_reader :project_files, :next_file_id

        def initialize(project_files:, next_file_id:)
          @project_files = project_files
          @next_file_id = next_file_id
        end

        def more_files?
          !!next_file_id
        end

        def no_more_files?
          !next_file_id
        end
      end
    end
  end
end
