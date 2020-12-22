FactoryBot.define do
  sequence :project_id do
    "project-#{rand(1000...10_000)}"
  end

  factory :project_source, class: 'DX::Api::Project::Source' do
    id { generate(:project_id) }
    object_ids { [] }

    trait :with_object_ids do
      object_ids { %w[file-1234 file-5678 file-9012] }
    end

    initialize_with { new(id: id, object_ids: object_ids) }
  end

  factory :project_destination, class: "DX::Api::Project::Destination" do
    id { generate(:project_id) }

    initialize_with { new(id: id) }
  end
end