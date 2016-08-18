namespace :legacy do

  task load_legacy_models: :environment do
    Dir[File.join(Rails.root, 'lib', 'legacy', '*.rb')].each { |file| require file }
  end

  desc 'Migrate old designers'
  task designers: [:load_legacy_models] do
    Legacy::Designer.migrate_all!
  end

  desc 'Migrate old products'
  task products: [:load_legacy_models] do
    Legacy::Produkt.migrate_all!
  end

  desc 'Migrate old customers'
  task customers: [:load_legacy_models] do
    Legacy::Benutzer.migrate_all!
  end

  desc 'Migrate all'
  task migrate: [:designers, :products, :customers]

end
