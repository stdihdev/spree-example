Spree::OptionValue.class_eval do

  default_scope -> { joins(:translations).distinct }

  scope :in_variants, -> (variants) { joins(:variants).where("#{Spree::Variant.quoted_table_name}.id": variants).uniq }
  scope :in_products, -> (products) { joins(:variants).where("#{Spree::Variant.quoted_table_name}.product_id": products).uniq }
  scope :in_taxon, -> (taxon) { joins(variants: { product: :taxons }).where("#{Spree::Taxon.quoted_table_name}.id": taxon.id).uniq }

end
