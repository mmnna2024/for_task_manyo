FactoryBot.define do

  factory :user, class: User do
    name { "User1" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "user1des" }
    admin { false }
  end

  factory :user2, class: User do
    name { "User2" }
    email { "user2@gmail.com" }
    password { "user2des" }
    admin { true }
  end
end
