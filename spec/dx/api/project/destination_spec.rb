RSpec.describe DX::Api::Project::Destination do
  subject(:destination) { described_class.new(id: 'project-1234') }

  describe '#create_folders' do
    context 'with default arguments' do
      subject { destination.create_folders }

      it { is_expected.to be true }
    end
  end

  describe '#folder' do
    context 'with default arguments' do
      subject { destination.folder }

      it { is_expected.to eq '/' }
    end
  end
end
