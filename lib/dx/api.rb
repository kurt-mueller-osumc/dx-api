# frozen_string_literal: true

require 'dx/api/file'
require 'dx/api/request'
require 'dx/api/response'
require 'dx/api/project/description'
require 'dx/api/project/invitation'
require 'dx/api/project'
require 'dx/api/search'
require 'dx/api/data_objects'
require 'dx/api/version'

module DX
  module Api
    HOST_NAME = 'https://api.dnanexus.com'

    class Error < StandardError; end

    class InvalidAuthenticationError < Error; end

    class InvalidInputError < Error; end

    class InvalidStateError < Error; end

    class InvalidTypeError < Error; end

    class PermissionDeniedError < Error; end

    class ResourceNotFoundError < Error; end

    class SpendingLimitExceededError < Error; end

    # Handles erros when the response body contains the "error" key
    class ErrorHandler
      def self.from_response(resp)
        error = resp.body.fetch('error')
        code = resp.code

        new(type: error.fetch('type'),
            message: error.fetch('message'),
            code: code)
      end

      attr_reader :type, :message, :code

      def initialize(type:, message:, code:)
        @type = type
        @message = message
        @code = code
      end

      def error
        case type
        when 'InvalidAuthentication' then InvalidAuthenticationError
        when 'InvalidInput'          then InvalidInputError
        when 'InvalidState'          then InvalidStateError
        when 'InvalidType'           then InvalidTypeError
        when 'PermissionDenied'      then PermissionDeniedError
        when 'ResourceNotFound'      then ResourceNotFoundError
        when 'SpendingLimitExceeded' then SpendingLimitExceededError
        else Error # catch all for any errors not defined yet
        end
      end

      def raise!
        raise error, message
      end
    end
  end
end
