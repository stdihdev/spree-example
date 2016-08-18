FactoryGirl.define do

  factory :designer_label, class: Nelou::DesignerLabel do
    name Faker::Name.name
    profile Faker::Lorem.paragraphs.join('\n')
    active true
    accepted true
    short_description Faker::Lorem.paragraph
    association :user, factory: :designer

    factory :disabled_designer_label do
      active false
    end

    factory :not_accepted_designer_label do
      accepted false
    end
  end

end
