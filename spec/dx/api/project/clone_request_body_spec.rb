RSpec.describe DX::Api::Project::CloneRequestBody do
  subject { described_class }

  describe "#to_h" do
    let(:source) { build(:project_source) }
    let(:dest) { build(:project_destination) }

    subject(:body) { described_class.new(source, dest).to_h }

    it { is_expected.to have_key(:project) }

    it 'has :project value of destination id' do
      expect(body.fetch(:project)).to eq(dest.id)
    end

    context "when source object ids are present" do
      let(:source) { build(:project_source, :with_object_ids) }

      it { is_expected.to have_key(:objects) }
    end

    context "when source folders are present" do
      let(:source) { build(:project_source, :with_folders) }

      it { is_expected.to have_key(:folders) }
    end

    context 'when destination folder is present (and is not root folder)' do
      let(:dest) { build(:project_destination, folder: 'output_folder') }

      it { is_expected.to have_key(:destination) }
    end
  end
end