FactoryGirl.define do
  factory :user do
    sequence :email { |x| "test#{x}@email.com" }
    first_name "test"
    last_name "example"
    password "password"
  end
end
