class AddPhotoCreditsToProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :photo_credits, :string, null: true, limit: 255
  end
end
