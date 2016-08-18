class AddSoldOutToProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :sold_out, :boolean, null: false, default: false
    add_index :spree_products, :sold_out
    add_index :spree_products, [:deleted_at, :available_on, :sold_out], name: 'index_spree_products_on_available_on_and_sold_out'

    add_index :spree_variants, [:is_master, :deleted_at]

    Spree::Product.transaction do
      Spree::Product.all.find_each do |p|
        begin
          p.save!
        rescue => e
          puts "Problem with #{p.id}: #{e.message}"
        end
      end
    end
  end
end
