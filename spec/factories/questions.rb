FactoryGirl.define do
  factory :question do
    sequence(:title) { |n| "title for #{n} question" }
    sequence(:body)  { |n| "body for #{n} question" }

    factory :invalid_question do
      title nil
      body nil
    end
  end
end
