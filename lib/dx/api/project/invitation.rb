module DX
  module Api
    module Project
      class Invitation
        PERMISSIONS = {
          viewer: 'VIEW',
          uploader: 'UPLOAD',
          contributor: 'CONTRIBUTE',
          administrator: 'ADMINISTER'
        }.freeze

        def self.as_viewer(invitee:, send_email: true)
          new(
            invitee: invitee,
            level: PERMISSIONS.fetch(:viewer),
            send_email: send_email
          )
        end

        def self.as_contributor(invitee:, send_email: true)
          new(
            invitee: invitee,
            level: PERMISSIONS.fetch(:contributor),
            send_email: send_email
          )
        end

        def self.as_admin(invitee:, send_email: true)
          new(
            invitee: invitee,
            level: PERMISSIONS.fetch(:administrator),
            send_email: send_email
          )
        end

        attr_reader :invitee, :level, :send_email

        # Create a invitation for a DX project.
        #
        # @param invitee [String] An email address of a current DNAnexus user or a DNAnexus id
        # @param level [String] A permission level; must be one of "VIEW", "UPLOAD", "CONTRIBUTE", or "ADMINISTER"
        # @param send_email [Boolean] If true, send an email notification to the invitee
        def initialize(invitee:, level:, send_email: true)
          @invitee = invitee
          @level = level
          @send_email = send_email
        end

        def admin?
          level == PERMISSIONS.fetch(:administrator)
        end

        def viewer?
          level == PERMISSIONS.fetch(:viewer)
        end

        def contributor?
          level == PERMISSIONS.fetch(:contributor)
        end
      end
    end
  end
end
