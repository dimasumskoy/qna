FactoryGirl.define do
  factory :positive_vote do
    value 1
    user

    factory :negative_vote do
      value -1
      user
    end
  end
end
