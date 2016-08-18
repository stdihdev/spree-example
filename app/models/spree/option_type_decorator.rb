Spree::OptionType.class_eval do

  default_scope -> { joins(:translations).distinct }
  scope :in_products, -> (products) { joins(:option_values).merge(Spree::OptionValue.in_products(products)) }
  scope :in_taxon, -> (taxon) { joins(:option_values).merge(Spree::OptionValue.in_taxon(taxon)) }

  def self.colour
    Spree::OptionType.find_or_create_by(name: 'Colour') do |c|
      c.name = 'Colour'
      c.presentation = 'Colour'
    end
  end

  def option_values_in_products(ids)
    option_values.in_products(ids)
      .joins(:translations)
      .select("#{Spree::OptionValue.quoted_table_name}.*, spree_option_value_translations.presentation")
      .with_locales(I18n.locale)
      .reorder('spree_option_value_translations.presentation ASC')
      .to_a
      .uniq(&:id)
  end

  def option_values_in_taxon(taxon)
    option_values.in_taxon(taxon)
      .joins(:translations)
      .select("#{Spree::OptionValue.quoted_table_name}.*, spree_option_value_translations.presentation")
      .with_locales(I18n.locale)
      .reorder('spree_option_value_translations.presentation ASC')
      .to_a
      .uniq(&:id)
  end

end
