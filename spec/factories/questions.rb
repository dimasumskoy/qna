FactoryGirl.define do
  factory :question do
    title 'title sample'
    body  'body sample'
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end
