class Enterprise::PartnerService

  def initialize(user)
    @user = user
  end

  def update!(always_save = false)
    if @user.email_changed? || always_save
      begin
        partner = Enterprise::Partner.find(@user.enterprise_partner_id)
        partner.name = @user.email
        partner.save!
      rescue ActiveResource::ResourceNotFound, ActiveResource::ResourceConflict, ActiveResource::ResourceInvalid
        return create!
      end
    end
  end

  def create!
    partner = Enterprise::Partner.new(name: @user.email)
    partner.save!

    @user.enterprise_partner_id = partner.id
    @user.update_attribute :enterprise_partner_id, partner.id
  end

  def save!(always_save = false)
    return if Rails.application.secrets.skip_enterprise
    if has_partner_id
      update!(always_save)
    else
      create!
    end
  end

  private

  def has_partner_id
    @user.enterprise_partner_id.present?
  end
end
