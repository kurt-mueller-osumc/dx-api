module DX
  module Api
    module ProjectFile
      class Query

        attr_reader :project_id, :folder, :with_name, :starting_at

        def initialize(project_id:, folder: '/', with_name: nil, starting_at: nil)
          @project_id = project_id
          @folder = folder
          @with_name = with_name
          @starting_at = starting_at
        end

        def to_h
          {
            scope: {
              project: project_id,
              folder: folder,
              recurse: true,
            },
            describe: true,
            class: 'file',
          }.tap do |hash|
            add_starting_at(hash) unless starting_at.nil?
            add_search_phrase(hash) unless with_name.nil?
          end
        end

        private

        # start query at a specific file
        def add_starting_at(hash)
          hash.merge!({
            starting: {
              project: project_id,
              id: starting_at
            }
          })
        end

        def add_search_phrase(hash)
          hash.merge!({
            name: {
              regexp: with_name
            }
          })
        end
      end
    end
  end
end
