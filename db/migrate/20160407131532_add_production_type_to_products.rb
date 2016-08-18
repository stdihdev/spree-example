class AddProductionTypeToProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :production_type, :string, null: false, limit: 20, default: 'ready_to_wear'
    add_index :spree_products, :production_type
  end
end
