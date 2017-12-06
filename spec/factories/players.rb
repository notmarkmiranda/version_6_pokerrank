FactoryGirl.define do
  factory :player do
    game
    finishing_place 1
    additional_expense 10
    score 1.5
    user
  end
end
