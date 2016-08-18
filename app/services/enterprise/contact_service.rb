class Enterprise::ContactService

  def initialize(user)
    @user = user
  end

  def update!(always_save = false)
    if has_contact_id && (@user.changed? || always_save)
      begin
        contact = find_contact(@user.enterprise_contact_id)
        contact.prefix_options[:partner_id] = @user.enterprise_partner_id
        contact.primary = true
        contact.name = @user.name
        contact.email = @user.email
        contact.phone = @user.phone
        contact.save!
      rescue ActiveResource::ResourceNotFound, ActiveResource::ResourceConflict, ActiveResource::ResourceInvalid
        return create!
      end
    end
  end

  def create!
    contact = Enterprise::Contact.new(name: @user.name, email: @user.email, primary: true, partner_id: @user.enterprise_partner_id)
    contact.prefix_options[:partner_id] = @user.enterprise_partner_id

    contact.save!
    @user.enterprise_contact_id = contact.id
    @user.update_attribute :enterprise_contact_id, contact.id
  end

  def save!(always_save = false)
    return if Rails.application.secrets.skip_enterprise
    if has_contact_id && has_partner_id
      update!(always_save)
    else
      create!
    end
  end

  private

  def find_contact(id)
    if @user.enterprise_partner_id.blank?
      nil
    else
      Enterprise::Contact.find id, params: { partner_id: @user.enterprise_partner_id }
    end
  end

  def has_contact_id
    @user.enterprise_contact_id.present?
  end

  def has_partner_id
    @user.enterprise_partner_id.present?
  end
end
