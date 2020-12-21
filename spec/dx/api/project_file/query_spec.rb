RSpec.describe DX::Api::ProjectFile::Query do
  describe '#to_h' do
    context 'when starting_at is present' do
      describe 'hash' do
        subject { described_class.new(project_id: 'project-1234', starting_at: 'file-1234').to_h }

        it { is_expected.to have_key(:starting) }
      end

      describe 'hash[:starting]' do
        subject { described_class.new(project_id: 'project-1234', starting_at: 'file-1234').to_h.fetch(:starting) }

        it { is_expected.to have_key(:project) }
        it { is_expected.to have_key(:id) }
      end
    end
  end
end
