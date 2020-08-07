module DX
  module Api
    # https://documentation.dnanexus.com/developer/api/search
    module Search
      # Searches for data objects satisfying particular constraints
      # https://documentation.dnanexus.com/developer/api/search#api-method-system-finddataobjects
      #
      # @param api_token [String] Your DNAnexus api token
      # @param project_id [String] The full id of the project
      # @param starting_at [String/NilClass] The object id to start at (optional)
      # @returns [DX::Api::Response] The response from the api
      def self.find_data_objects(api_token:, project_id:, starting_at: nil)
        query = DataObjectsQuery.new(project_id: project_id, starting_at: starting_at)

        DX::Api::Request.new(
          api_token: api_token,
          path: %w[system findDataObjects].join('/'),
          body: query.to_h
        ).make.then(&::DX::Api::Response.method(:from_http))
      end

      # Helper class to create data object queries.
      class DataObjectsQuery
        attr_reader :project_id,
                    :starting_at

        def initialize(project_id:, starting_at: nil)
          @project_id = project_id
          @starting_at = starting_at
        end

        def to_h
          if starting_at.nil?
            basic_hash
          else
            basic_hash.merge({
              starting: {
                project: project_id,
                id: starting_at
              }
            })
          end
        end

        private

        def basic_hash
          {
            scope: {
              project: project_id,
              recurse: true
            },
            describe: true
          }
        end
      end
    end
  end
end
