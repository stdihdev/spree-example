namespace :enterprise do

  desc 'Export designers to enterprise'
  task designers: :environment do
    puts 'Exporting all designers'
    Nelou::DesignerLabel.each do |designer_label|
      next unless designer_label.user.present?
      next if designer_label.user.enterprise_partner_id.present?

      begin
        Enterprise::PartnerService.new(designer_label.user).save!(true)
        Enterprise::ContactService.new(designer_label.user).save!(true) if designer_label.user.bill_address.present?
      rescue => e
        puts "Problem with #{designer_label.name}: #{e}"
      end
    end
  end

  desc 'Export customers'
  task customers: :environment do
    puts 'Exporting all customers'
    Spree::User.where(enterprise_partner_id: nil).each do |user|
      begin
        Enterprise::PartnerService.new(user).save!(true)
        Enterprise::ContactService.new(user).save!(true) if user.bill_address.present?
        print '.'
      rescue => e
        puts "Problem with #{user.email}: #{e}"
      end
    end
  end

  desc 'Export addresses'
  task addresses: :environment do
    puts 'Exporting all addresses'
    Spree::Address.joins(:user).where(enterprise_id: nil).each do |address|
      begin
        Enterprise::AddressService.new(address).save!(true)
        print '.'
      rescue => e
        puts "Problem with #{address.email}: #{e}"
      end
    end
  end

end
