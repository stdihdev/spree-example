Spree::Address.class_eval do

  after_save :save_in_enterprise

  validates :gender, inclusion: { in: %w(m f) }, presence: true

  def self.whitelisted_ransackable_associations
    %w(country)
  end

  def self.build_default
    new
  end

  def require_phone?
    false
  end

  def name
    [firstname, lastname].reject(&:nil?).reject(&:empty?).join ' '
  end

  def male?
    gender == 'm'
  end

  def female?
    gender == 'f'
  end

  def address
    [address1, address2].reject(&:nil?).reject(&:empty?).join "\n"
  end

  def postcode
    zipcode
  end

  protected

  def save_in_enterprise
    if user.present?
      Enterprise::AddressService.new(self).save!
      Enterprise::ContactService.new(user).save! if user.try(:bill_address).present?
    end
  end

end
