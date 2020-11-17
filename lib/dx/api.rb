# frozen_string_literal: true

require 'dx/api/file'
require 'dx/api/project'
require 'dx/api/request'
require 'dx/api/response'
require 'dx/api/search'
require 'dx/api/data_objects'
require 'dx/api/version'

module DX
  module Api
    HOST_NAME = 'https://api.dnanexus.com'

    class Error < StandardError; end
  end
end
