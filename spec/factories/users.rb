FactoryGirl.define do
  factory :user, aliases: [:creator] do
    sequence :email { |x| "test#{x}@email.com" }
    sequence :first_name { |x| "test#{x}" }
    last_name "example"
    password "password"
  end
end

