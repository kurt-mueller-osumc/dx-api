RSpec.describe DX::Api::ProjectFile::SearchResult do
  describe '#more_files?' do
    context 'when next file id is not present' do
      subject(:search_result) { described_class.new(project_files: [], next_file_id: nil).more_files? }

      it { is_expected.to be false }
    end

    context 'when next file id is present' do
      subject(:search_result) { described_class.new(project_files: [], next_file_id: 'file-1234').more_files? }

      it { is_expected.to be true }
    end
  end
end
