FactoryGirl.define do
  factory :comment do
    sequence(:body)  { |n| "body for #{n} comment" }
    user

    factory :invalid_comment do
      body nil
    end
  end
end
