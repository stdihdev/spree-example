module Nelou
  class SizeOptionType < Spree::OptionType
    AVAILABLE_COUNTRY_CHOICES = %w(US DE UK IT FR DK RU AU JP)

    has_many :size_option_values, class_name: 'Nelou::SizeOptionValue', foreign_key: :option_type_id

    accepts_nested_attributes_for :size_option_values

    validates :country_code, allow_blank: true, inclusion: { in: AVAILABLE_COUNTRY_CHOICES }
  end
end
