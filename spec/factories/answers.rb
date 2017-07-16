FactoryGirl.define do
  factory :answer do
    sequence(:body) { |n| "body for #{n} answer" }

    factory :invalid_answer do
      body nil
    end
  end
end
