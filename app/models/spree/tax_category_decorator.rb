Spree::TaxCategory.class_eval do

  def self.default
    Spree::TaxCategory.find_or_create_by(name: 'Default') do |t|
      t.name = 'Default'
      t.is_default = true
    end
  end

end
