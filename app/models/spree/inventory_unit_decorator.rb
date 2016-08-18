Spree::InventoryUnit.class_eval do
  has_one :designer_label, through: :line_item
end
