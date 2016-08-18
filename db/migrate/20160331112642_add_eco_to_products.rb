class AddEcoToProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :eco, :boolean, null: false, default: false
    add_index :spree_products, :eco
  end
end
