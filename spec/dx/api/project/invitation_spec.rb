RSpec.describe DX::Api::Project::Invitation do
  subject(:invitation) { described_class }

  describe '.as_admin' do
    describe '#level' do
      subject { invitation.as_admin(invitee: 'user-james.solove').level }

      it { is_expected.to eq 'ADMINISTER' }
    end
  end

  describe '.as_contributor' do
    describe '#level' do
      subject { invitation.as_contributor(invitee: 'user-james.solove').level }

      it { is_expected.to eq 'CONTRIBUTE' }
    end
  end

  describe '.as_viewer' do
    describe '#level' do
      subject { invitation.as_viewer(invitee: 'user-james.solove').level }

      it { is_expected.to eq 'VIEW' }
    end
  end
end
