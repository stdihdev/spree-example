class Enterprise::AddressService

  def initialize(address)
    @address = address
    @user = address.user
  end

  def update!(always_save = false)
    if @address.changed? || always_save
      begin
        address = find_address(@address.enterprise_id)
        address.prefix_options[:partner_id] = @user.enterprise_partner_id
        address.primary = @address == @user.bill_address
        address.addition = ''
        address.company = @address.company.present? ? @address.company : @address.name
        address.street = @address.address1
        address.street2 = @address.address2
        address.city = @address.city
        address.postcode = @address.postcode
        address.country = @address.country.try(:iso)
        address.sales_tax_id = @user.designer_label.try(:vat) if @user.designer?
        address.save!
      rescue ActiveResource::ResourceNotFound, ActiveResource::ResourceConflict, ActiveResource::ResourceInvalid
        return create!
      end
    end
  end

  def create!
    if @user.enterprise_partner_id.present?
      address = Enterprise::Address.new({
        company: @address.company.present? ? @address.company : @address.name,
        addition: '',
        street: @address.address,
        street2: @address.address2,
        city: @address.city,
        postcode: @address.postcode,
        country: @address.country.try(:iso),
        sales_tax_id: @user.designer? ? @user.designer_label.try(:vat) : nil,
        primary: @address == @user.bill_address,
        partner_id: @user.enterprise_partner_id
      })
      address.prefix_options[:partner_id] = @user.enterprise_partner_id

      address.save!
      @address.enterprise_id = address.id
      @address.update_attribute :enterprise_id, address.id
    end
  end

  def save!(always_save = false)
    return if Rails.application.secrets.skip_enterprise
    if has_enterprise_id
      update!(always_save)
    else
      create!
    end
  end

  private

  def find_address(id)
    if @user.enterprise_partner_id.blank?
      nil
    else
      Enterprise::Address.find id, params: { partner_id: @user.enterprise_partner_id }
    end
  end

  def has_enterprise_id
    @address.enterprise_id.present?
  end
end
