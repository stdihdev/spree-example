Spree::User.class_eval do
  include Nelou::Legacy::Login
  include Nelou::Legacy::Password
  include Nelou::User::Subscription

  has_one :designer_label, class_name: 'Nelou::DesignerLabel', dependent: :destroy, autosave: true, inverse_of: :user
  has_many :products, through: :designer_label

  delegate :firstname, :lastname, :name, :male?, :female?, :phone, to: :bill_address, allow_nil: true

  accepts_nested_attributes_for :designer_label
  accepts_nested_attributes_for :bill_address

  before_save :ensure_designer_label_exists
  before_save :ensure_bill_and_ship_address_are_mine
  before_save :save_in_enterprise
  before_create :set_locale

  scope :designers, -> { includes(:spree_roles).where("#{Spree::Role.quoted_table_name}.name" => 'designer') }

  attr_accessor :terms_and_services, :privacy_and_conditions

  validates :terms_and_services, acceptance: true, on: :create
  validates :privacy_and_conditions, acceptance: true, on: :create

  def designer?
    has_spree_role?('designer') || has_spree_role_in_array?('designer')
  end

  # For Mailchimp, which doesn't work with true/false
  def designer_integer
    designer? ? 1 : 0
  end

  def approved?
    designer? && designer_label.present? && designer_label.accepted && designer_label.active
  end

  protected

  def set_locale
    self.locale = I18n.locale unless self.locale.present?
  end

  def ensure_designer_label_exists
    if designer? && designer_label.nil?
      build_designer_label name: email.split('@').first
    end
  end

  def has_spree_role_in_array?(role)
    spree_roles.to_a.any? do |spree_role|
      spree_role.name == role.to_s
    end
  end

  def ensure_bill_and_ship_address_are_mine
    [ship_address, bill_address].each do |address|
      if address.present? && address.user.nil?
        address.user = self if address.present?
        address.save
      end
    end
  end

  def save_in_enterprise
    Enterprise::PartnerService.new(self).save!
    Enterprise::ContactService.new(self).save! if bill_address.present?
  end
end
