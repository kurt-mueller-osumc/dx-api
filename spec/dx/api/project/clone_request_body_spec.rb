RSpec.describe DX::Api::Project::CloneRequestBody do
  subject { described_class }

  describe "#to_h" do
    context "when source object ids are present" do
      let(:source) { build(:project_source, :with_object_ids) }
      let(:dest) { build(:project_destination) }

      subject(:body) { described_class.new(source, dest).to_h }

      it { is_expected.to have_key(:objects) }
    end
  end
end