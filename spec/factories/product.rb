# Caught for now, no idea why this leads into an dependency hell

require 'spree/testing_support/factories'

begin
  FactoryGirl.modify do

    factory :base_product do
      association :designer_label, factory: :designer_label
      taxons { [FactoryGirl.create(:taxon)] }
    end

  end

rescue
end
