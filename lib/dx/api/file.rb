module DX
  module Api
    module File
      # Clone a file, based on its id, from a source container (e.g. a source project) to a folder path in a destination container (e.g. a destination project)
      #
      #    DX::Api::File.clone(
      #      api_token: "API_TOKEN",
      #      file_id: "file-1234",
      #      source_id: "project-1234",
      #      destination_id: "project-4567",
      #      folder_path: "destination/folder/path",
      #    )
      #
      # @param api_token [String] Your api token
      # @param file_id [String] The id of the file to clone
      # @param source_id [String] The id of the source container
      # @param destination_id [String] The id of the destination container
      # @param folder_path [String] The folder path to copy the file to
      # @return [DX::Api::Response] A dx response whose body contains the ids of the source container, destination container, as well as an array of objects tha tcould not be cloned since they already exist in the container
      def self.clone(api_token:, file_id:, source_id:, destination_id:, folder_path:) 
        DX::Api.request.new(
          api_token: api_token,
          path: [source_id, 'clone'].join('/'), # e.g. project-1234/clone
          body: {
            project: destination_id, # the destination container
            objects: [file_id],
            destination: folder_path,
            parents: true
          }
        ).make.then(&DX::Api::Response.method(:from_http))
      end
    end
  end
end
