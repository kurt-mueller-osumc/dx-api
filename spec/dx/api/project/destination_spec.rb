RSpec.describe DX::Api::Project::Destination do
  subject(:destination) { described_class.new(id: 'project-1234') }

  describe '#folder' do
    context 'with default arguments' do
      it { is_expected.to be_root_folder }
    end
  end
end
