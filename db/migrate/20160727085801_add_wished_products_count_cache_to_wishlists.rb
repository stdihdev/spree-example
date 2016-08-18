class AddWishedProductsCountCacheToWishlists < ActiveRecord::Migration
  def change
    add_column :spree_wishlists, :wished_products_count_cache, :integer, null: false, default: 0
    add_index :spree_wishlists, :wished_products_count_cache

    Spree::Wishlist.all.each do |w|
      w.update_column :wished_products_count_cache, w.wished_products.count
    end
  end
end
