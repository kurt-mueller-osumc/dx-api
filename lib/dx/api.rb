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

    # Thrown when a dnanexus token could not be used to authenticate against the
    # dnanexus api
    class InvalidAuthenticationError < StandardError
      def initialize(msg = 'The provided token could not be found')
        super
      end
    end

    class ResourceNotFoundError < StandardError
      def initialize(msg = 'The specified URL could not be found')
        super
      end
    end

    class PermissionDeniedError < StandardError; end

    class ErrorHandler
      attr_reader :type, :message, :code

      def initialize(type:, message:, code:)
        @type = type
        @message = message
        @code = code
      end

      def error_type
        case type
        when 'InvalidAuthentication' then InvalidAuthenticationError
        when 'ResourceNotFound'      then ResourceNotFoundError
        when 'PermissionDenied'      then PermissionDeniedError
        end
      end

      def raise!
        return if error_type.nil?

        raise error_type, message
      end
    end
  end
end
