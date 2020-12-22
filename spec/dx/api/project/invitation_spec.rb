RSpec.describe DX::Api::Project::Invitation do
  subject(:invitation) { described_class }

  describe '.as_admin' do
    subject { invitation.as_admin(invitee: 'user-james.solove') }

    it { is_expected.to be_admin  }
  end

  describe '.as_contributor' do
    subject { invitation.as_contributor(invitee: 'user-james.solove') }

    it { is_expected.to be_contributor }
  end

  describe '.as_viewer' do
    subject { invitation.as_viewer(invitee: 'user-james.solove') }

    it { is_expected.to be_viewer }
  end
end
