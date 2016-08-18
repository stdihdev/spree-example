module Nelou
  class DesignerLabel < Nelou::BaseModel
    belongs_to :user, class_name: 'Spree::User'
    has_many :products, dependent: :nullify, class_name: 'Spree::Product'

    translates :name, :profile, :short_description, :slug, fallbacks_for_empty_translations: true

    extend FriendlyId

    friendly_id :name, use: [:history, :globalize, :finders]

    include Spree::RansackableAttributes
    include SpreeI18n::Translatable
    include Nelou::HasCustomFileName
    include Nelou::AttachmentFromUrl

    after_commit :check_designer_group

    default_scope -> { joins(:translations) }
    scope :active, -> { where(active: true, accepted: true) }
    scope :featured, -> { where(featured: true) }
    scope :with_name_like, -> (name) { where("#{Nelou::DesignerLabel.quoted_table_name}.name ILIKE ? OR nelou_designer_label_translations.name ILIKE ?", "%#{name}%", "%#{name}%") }

    self.whitelisted_ransackable_attributes = %w[id name accepted active featured]

    has_attached_file :logo,
                      styles: { profile: 'x50>', profile_2x: 'x100>' },
                      default_url: '/images/missing/logos/:style.png'
    validates_attachment_content_type :logo, content_type: /\Aimage\/(png|jpeg|gif)\Z/
    has_custom_file_name :logo, :generate_hex_for_file_name

    has_attached_file :profile_image,
                      styles: { profile: '360x330>', profile_2x: '720x660>' },
                      default_url: '/images/missing/profile-images/:style.png'
    validates_attachment_content_type :profile_image, content_type: /\Aimage\/(png|jpeg|gif)\Z/
    has_custom_file_name :profile_image, :generate_hex_for_file_name

    has_attached_file :teaser_image,
                      styles: { slider: '780x268>', slider_2x: '1560x536>' },
                      default_url: '/images/missing/teaser-images/:style.png'
    validates_attachment_content_type :teaser_image, content_type: /\Aimage\/(png|jpeg|gif)\Z/
    has_custom_file_name :teaser_image, :generate_hex_for_file_name

    allow_from_url :logo, :profile_image, :teaser_image

    validates :user, presence: true
    validates :background_colour, presence: true
    validates :name, presence: true, length: { maximum: 255 }

    def self.for_slider
      active.featured.order(created_at: :desc).uniq
    end

    def has_products_on_sale?
      products.active.on_sale.any?
    end

    def first_letter
      if name.present?
        name.strip[0].upcase
      else
        '?'
      end
    end

    private

    def self.ransackable_associations(auth_object = nil)
      reflect_on_all_associations.map { |a| a.name.to_s }
    end

    def check_designer_group
      Nelou::Mailchimp::AssignUserToGroupJob.perform_later user.id
    end
  end
end
