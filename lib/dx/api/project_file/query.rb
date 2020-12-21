module DX
  module Api
    module ProjectFile
      class Query

        attr_reader :project_id, :starting_at

        def initialize(project_id:, starting_at: nil)
          @project_id = project_id
          @starting_at = starting_at
        end

        def to_h
          {
            scope: {
              project: project_id,
              recurse: true
            },
            describe: true,
            class: 'file'
          }.tap do |hash|
            unless starting_at.nil?
              hash.merge!(
                {
                  starting: {
                    project: project_id,
                    id: starting_at
                  }
                }
              )
            end
          end
        end
      end
    end
  end
end
