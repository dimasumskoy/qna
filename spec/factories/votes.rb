FactoryGirl.define do
  factory :vote do
    value 1
    user

    factory :negative_vote do
      value -1
      user
    end
  end
end
