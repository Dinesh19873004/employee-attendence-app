FactoryBot.define do
  factory :employee do
    name { "John Doe" }
    email { "john@example.com" }
    password { "Password@123" }
    association :admin
  end
end
