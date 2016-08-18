class AddLimitedToVariants < ActiveRecord::Migration
  def change
    add_column :spree_variants, :limited, :boolean, null: false, default: false
    add_column :spree_variants, :limited_items, :integer, null: true
    add_column :spree_variants, :limited_items_sold, :integer, null: true, default: 0
    add_index :spree_variants, [:limited, :limited_items, :limited_items_sold], name: :index_spree_variants_on_limited_and_limited_items
  end
end
