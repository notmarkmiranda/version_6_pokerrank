FactoryGirl.define do
  factory :user_league_role do
    user
    league

    trait :regular_user do
      role 0
    end

    trait :admin do
      role 1
    end
  end
end
