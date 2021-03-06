FactoryGirl.define do
  factory :malady, class: 'Maladie' do
    code "MyString"
    parent_id "MyString"
    ancestry "MyString"
    chapter "MyString"
    name "MyString"
  end
  factory :user do
    sequence(:username) { |n| "user#{n}" }
    email { |user| "#{user.username}@example.com".downcase }
    password 'password'
    password_confirmation { |user| user.password }
    centre

    factory :member do
      after(:create, &:approve!)

      factory :admin do
        sequence(:username) { |n| "admin#{n}" }
        email { |admin| "#{admin.username}@example.com".downcase }
        after(:create) { |user| user.add_role :admin }
      end
    end
  end

  factory :centre do
    sequence(:name) { |n| "centre#{n}" }
    sequence(:code) { |n| "c#{n}" }
  end

  factory :dossier do
    sequence(:code) { |n| "dossier#{n}" }
    sequence(:name) { |n| "name#{n}" }
    date_appel Time.zone.now.to_date
    expo_terato 'Oui'
    a_relancer 'Oui'
    centre
    user
    demandeur
    transient do
      produits_count 1
    end

    before(:create) do |dossier, evaluator|
      dossier.expositions = create_list(:exposition, evaluator.produits_count, dossier: dossier)
    end

    factory :dossier_a_relancer do
      a_relancer 'Oui'
      relance
    end
  end

  factory :exposition do
    produit
    expo_terme
    indication
    dossier
  end

  factory :demandeur do
    correspondant
  end

  factory :relance do
    correspondant
  end

  factory :correspondant do
    nom 'Martin'
    ville { centre.name.titleize }
    cp '69006'
    centre
    specialite
  end

  factory :specialite do
    name 'généraliste'
  end

  factory :produit do
    sequence(:name) { |n| "Produit#{n}" }
  end

  factory :expo_terme do
    sequence(:name) { |n| "Terme#{n}" }
  end

  factory :indication do
    sequence(:name) { |n| "Indication#{n}" }
  end

  factory :bebe do
    sexe 'm'
  end

  factory :malformation do
    sequence(:libelle) { |n| "Malformation#{n}" }
  end

  factory :pathology do
    sequence(:libelle) { |n| "Pathologie#{n}" }
  end

  factory :evolution do
    sequence(:name) { |n| "Evolution#{n}" }
  end
end
