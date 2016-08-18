class AddLocaleToUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :locale, :string, limit: 5, null: false, default: :en
  end
end
