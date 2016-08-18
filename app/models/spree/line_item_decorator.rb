Spree::LineItem.class_eval do
  has_one :designer_label, through: :product

  scope :by_designer, -> (designer_label) { joins(:product).where("#{Spree::Product.quoted_table_name}.designer_label": designer_label) }
end
