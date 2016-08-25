FactoryGirl.define do
  factory :post do
    title "I'm a title"
    body "I'm a body"
    user_id 1
    topic_id 1

    trait :with_image do
      image { fixture_file_upload("#{::Rails.root}/spec/fixtures/watch.jpg") }
    end

    trait :sequenced_email do
      sequence(:post) { |n| "I'm title #{n}" }
    end

    trait :sequenced_username do
      sequence(:body) { |n| "I'm body #{n}" }
    end
  end
end
