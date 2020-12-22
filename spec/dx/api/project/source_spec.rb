RSpec.describe DX::Api::Project::Source do
  subject { described_class }

  describe '#has_folders?' do
    subject { described_class.new(id: 'project-1234') }

    context 'when folder is root path: "/"' do
      it { is_expected.to_not have_folders }
    end
  end

  describe '#has_object_ids?' do
    subject { described_class.new(id: 'project-1234') }

    context 'when object ids are not present'do
      it { is_expected.to_not have_object_ids }
    end
  end
end