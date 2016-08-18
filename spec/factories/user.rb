FactoryGirl.define do

  factory :designer, parent: :user do
    before :create do |user|
      user.spree_roles << Spree::Role.find_or_create_by(name: 'designer')
      user.build_designer_label name: Faker::Name.name, accepted: true, active: true
    end
  end

  factory :unaccepted_designer, parent: :user do
    before :create do |user|
      user.spree_roles << Spree::Role.find_or_create_by(name: 'designer')
      user.build_designer_label name: Faker::Name.name, accepted: false, active: false
    end
  end

  factory :admin, parent: :user do
    before :create do |user|
      user.spree_roles << Spree::Role.find_or_create_by(name: 'admin')
    end
  end

  factory :confirmed_user, parent: :user do
    confirmed_at { Time.now }
    confirmation_sent_at { Time.now }
    confirmation_token '12345'
  end

end
