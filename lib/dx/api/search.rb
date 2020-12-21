# frozen_string_literal: true

module DX
  module Api
    # https://documentation.dnanexus.com/developer/api/search
    module Search
      # Searches for all files within a project. If the respone indicates another page exists,
      # it queries for the next page of data objects. If you pass in a block, you can work with
      # intermediatery results.
      #
      #    DX::Api::Search.find_all_files(
      #      api_token: YOUR_API_TOKEN,
      #      project_id: "project-1234"
      #    ) do |results|
      #      pp results
      #    end
      #
      # @param api_token [String] Your DNAnexus api token
      # @param project_id [String] The full id of the project
      # @param starting_at [String/NilClass] The object id to start at (optional)
      # @return [Array<Hash>] All the data objects in the project.
      def self.find_all_files(api_token:, project_id:, starting_at: nil, &block)
        query = DataObjectsQuery.new(project_id: project_id, starting_at: starting_at, entity_type: 'file')

        DX::Api::Request.new(
          api_token: api_token,
          path: %w[system findDataObjects].join('/'),
          body: query.to_h
        ).make.then(&::DX::Api::Response.method(:from_http)).then do |resp|
          next_page = dx_response.body.fetch('next')
          results = dx_response.body.fetch('results')

          result = DX::Api::Search::Result.from_resp(resp)

          block&.call(results)

          if next_page.nil?
            results
          else
            next_id = next_page.fetch('id')
            results.concat(
              find_all_files(api_token: api_token, project_id: project_id, starting_at: next_id, &block)
            )
          end
        end
      end

      # Helper class to create data object queries.
      class DataObjectsQuery
        ENTITY_TYPES = %w[record file applet workflow].freeze

        attr_reader :project_id,
                    :starting_at

        attr_accessor :entity_type

        def initialize(project_id:, starting_at: nil, entity_type: nil)
          @project_id = project_id
          @starting_at = starting_at
          @entity_type = entity_type
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
          }.then do |hash|
            entity_type.nil? ? hash : hash.merge(class: entity_type)
          end
        end
      end
    end
  end
end
