FactoryGirl.define do
  factory :topic do
    title "I'm a title"
    description "I'm a description"
    user_id 1

    trait :with_image do
      image { fixture_file_upload("#{::Rails.root}/spec/fixtures/watch.jpg") }
    end

    trait :sequenced_email do
      sequence(:title) { |n| "I'm topic #{n}" }
    end

    trait :sequenced_username do
      sequence(:description) { |n| "I'm description #{n}" }
    end
  end
end
