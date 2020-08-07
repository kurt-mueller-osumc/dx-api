module DX
  module Api
    # https://documentation.dnanexus.com/developer/api/search
    module Search
      # Searches for data objects satisfying particular constraints
      # https://documentation.dnanexus.com/developer/api/search#api-method-system-finddataobjects
      #
      # DX::Api::Search.find_data_objects(
      #   api_token: YOUR_API_TOKEN,
      #   project_id: "project-1234"
      # )
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

      # Searches for all data objects within a project. If the respone indicates another pages exists,
      # it queries for the next page of data objects. If you pass in a block, you'll be able to work with
      # intermediatery results.
      #
      # DX::Api::Search.find_all_data_objects(
      #   api_token: YOUR_API_TOKEN,
      #   project_id: "project-1234"
      # ) do |results|
      #   pp results
      # end
      #
      # @param api_token [String] Your DNAnexus api token
      # @param project_id [String] The full id of the project
      # @param starting_at [String/NilClass] The object id to start at (optional)
      # @returns [Array<Hash>] All the data objects in the project.
      def self.find_all_data_objects(api_token:, project_id:, starting_at: nil, &block)
        query = DataObjectsQuery.new(project_id: project_id, starting_at: starting_at)

        DX::Api::Request.new(
          api_token: api_token,
          path: %w[system findDataObjects].join('/'),
          body: query.to_h
        ).make.then(&::DX::Api::Response.method(:from_http))
        .then do |dx_response|
          next_page = dx_response.body.fetch("next")
          results = dx_response.body.fetch("results")

          block.call(results) unless block.nil?

          if next_page.nil?
            results
          else
            next_id = next_page.fetch("id")
            results.concat(
              find_all_data_objects(api_token: api_token, project_id: project_id, starting_at: next_id, &block)
            )
          end
        end
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
