Spree::ShippingCategory.class_eval do

  def self.paket
    Spree::ShippingCategory.find_or_create_by(name: 'Paket') do |p|
      p.name = 'Paket'
    end
  end

end
