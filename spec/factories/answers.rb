FactoryGirl.define do
  factory :answer do
    body 'answer body'

    factory :invalid_answer do
      body nil
    end
  end
end
