class AddDesignerLabelToSpreeProducts < ActiveRecord::Migration
  def change
    add_belongs_to :spree_products, :designer_label, index: true
  end
end
