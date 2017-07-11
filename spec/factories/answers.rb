FactoryGirl.define do
  factory :answer do
    body 'answer body'
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
  end
end
