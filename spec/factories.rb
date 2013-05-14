FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "user#{n}"}
    email { |user| "#{user.username}@example.com".downcase}
    password "password"
    password_confirmation { |user| user.password}
    centre

    factory :member do
      after(:create) {|user| user.approve!}

      factory :centre_admin do
        after(:create) {|user| user.add_role :centre_admin}
      end

      factory :admin do
        sequence(:username) { |n| "admin#{n}"}
        email { |admin| "#{admin.username}@example.com".downcase}
        after(:create) {|user| user.add_role :admin}
      end
    end
  end

  factory :centre do
    sequence(:name) { |n| "centre#{n}"}
    sequence(:code) { |n| "c#{n}"}
  end

  factory :dossier do
    sequence(:code) { |n| "dossier#{n}"}
    sequence(:name) { |n| "name#{n}"}
    expo_terato "Oui"
    a_relancer 1
    date_appel Time.now.to_date
    centre
    user
  end

  factory :correspondant do
    nom "Martin"
    ville { centre.name.titleize }
    cp "69006"
    centre
    specialite
  end

  factory :specialite do
    name "généraliste"
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

  factory :evolution do
    sequence(:name) {|n| "Evolution#{n}"}
  end
end
