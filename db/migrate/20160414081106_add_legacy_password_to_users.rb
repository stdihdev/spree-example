class AddLegacyPasswordToUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :legacy_password, :string, limit: 255, null: true
    add_column :spree_users, :legacy_password_hash, :string, limit: 255, null: true
  end
end
