FactoryBot.define do
  factory :admin do
    email { "admin@example.com" }
    password { "Password@123" }
    name { "Admin" }
  end
end
