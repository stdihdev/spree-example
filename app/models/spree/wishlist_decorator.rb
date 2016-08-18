Spree::Wishlist.class_eval do

  before_save :update_wished_products_count_cache

  private

  def update_wished_products_count_cache
    self.wished_products_count_cache = wished_products.count
    true
  end

end
