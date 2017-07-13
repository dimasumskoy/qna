FactoryGirl.define do
  factory :question do
    title 'title sample'
    body  'body sample'

    factory :invalid_question do
      title nil
      body nil
    end
  end
end
