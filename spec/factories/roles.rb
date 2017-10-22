FactoryGirl.define do
  factory :role do
    factory :super_role do
      name 'super'
    end

    factory :admin_role do
      name 'admin'
    end

    factory :user_role do
      name 'user'
    end
  end
end
