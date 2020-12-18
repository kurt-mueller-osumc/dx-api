require 'forwardable'

# A description of a DNAnexus project
class DX::Api::Project::Description
  extend Forwardable

  # Initialize a project description from a DX API response
  def self.from_response(resp)
    body = resp.body

    flags = Flags.from_response(resp)

    new(
      id: body.fetch('id'),
      name: body.fetch('name'),
      org: body.fetch('billTo'),
      summary: body.fetch('summary'),
      description: body.fetch('description'),
      flags: flags
    )
  end

  attr_reader :id, :name, :org, :summary, :description, :flags

  # A value object that represents a described project created by a successful response from
  # DNAnexus Project Describe API call.
  #
  # https://documentation.dnanexus.com/developer/api/data-containers/projects#api-method-project-xxxx-describe
  #
  # @param id [String] The id of the DNAnexus project
  # @param name [String] The name of the project
  # @param org [String] The organization that owns the project
  # @param summary [String] A summary of the project
  # @param description [String] A description of the project
  # @param flags [Flags] Access flags of the project
  def initialize(id:, name:, org:, summary:, description:, flags:)
    @id = id
    @name = name
    @org = org
    @summary = summary
    @description = description
    @flags = flags
  end

  # Delegate flag methods (download_restricted, contains_phi, etc) to Flags object
  def_delegators :flags, :download_restricted, :contains_phi, :is_protected, :restricted

  # Helper class that represents a project's access flags
  class Flags
    # Initialize a Flags object from a DX API response
    #
    # @param resp [DX:Api::Respone] A response object from a project describe request
    def self.from_response(resp)
      body = resp.body

      new(
        download_restricted: body.fetch('downloadRestricted'),
        contains_phi: body.fetch('containsPHI'),
        restricted: body.fetch('restricted'),
        is_protected: body.fetch('protected')
      )
    end

    attr_reader :download_restricted, :contains_phi, :is_protected, :restricted

    def initialize download_restricted:, contains_phi:, is_protected:, restricted:
      @download_restricted = download_restricted
      @contains_phi = contains_phi
      @is_protected = is_protected
      @restricted = restricted
    end
  end
end
