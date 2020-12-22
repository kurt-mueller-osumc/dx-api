FactoryBot.define do
  sequence :project_id do
    "project-#{rand(1000...10_000)}"
  end

  factory :project_source, class: 'DX::Api::Project::Source' do
    id { generate(:project_id) }
    object_ids { [] }
    folders { [] }

    trait :with_object_ids do
      object_ids { %w[file-1234 file-5678 file-9012] }
    end

    trait :with_folders do
      folders { %w[folder1 folder2] }
    end

    initialize_with { new(id: id, object_ids: object_ids, folders: folders) }
  end

  factory :project_destination, class: "DX::Api::Project::Destination" do
    id { generate(:project_id) }
    folder { '/' }

    initialize_with { new(id: id, folder: folder) }
  end
end