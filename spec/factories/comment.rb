FactoryGirl.define do
  factory :comment do
    body "I'm a body"
    user_id 1
    post_id 1

    trait :with_image do
      image { fixture_file_upload("#{::Rails.root}/spec/fixtures/watch.jpg") }
    end

    trait :sequenced_body do
      sequence(:body) { |n| "I'm body #{n}" }
    end

  end
end
