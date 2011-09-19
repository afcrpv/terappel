FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "user#{n}"}
    email { |user| "#{user.username}@example.com".downcase}
    password "password"
    password_confirmation { |user| user.password}
  end
end
