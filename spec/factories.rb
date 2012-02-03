FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "user#{n}"}
    email { |user| "#{user.username}@example.com".downcase}
    password "password"
    password_confirmation { |user| user.password}
    centre

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
    sequence(:code) { |n| "dossier#{n}"}
    sequence(:name) { |n| "name#{n}"}
    date_appel Time.now.to_date
    centre
    user
  end

  factory :correspondant do
    nom "Martin"
    ville { centre.name.titleize }
    cp "69006"
    centre
  end

  factory :produit do
    sequence(:name) {|n| "Produit#{n}"}
  end

  factory :expo_terme do
    sequence(:name) {|n| "Terme#{n}"}
  end

  factory :indication do
    sequence(:name) {|n| "Indication#{n}"}
  end

  factory :bebe do
    sexe "m"
  end

  factory :malformation do
    sequence(:libelle) {|n| "Malformation#{n}"}
  end

  factory :pathologie do
    sequence(:libelle) {|n| "Pathologie#{n}"}
  end
end
