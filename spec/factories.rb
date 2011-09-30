FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "user#{n}"}
    email { |user| "#{user.username}@example.com".downcase}
    password "password"
    password_confirmation { |user| user.password}

    factory :admin do
      sequence(:username) { |n| "admin#{n}"}
      email { |admin| "#{admin.username}@example.com".downcase}
      role "admin"
    end
  end

  factory :centre do
    sequence(:name) { |n| "centre#{n}"}
    sequence(:code) { |n| "c#{n}"}
  end

  factory :dossier do
    sequence(:name) { |n| "name#{n}"}
    date_appel Time.now.to_date
  end
end
