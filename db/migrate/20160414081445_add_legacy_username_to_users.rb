class AddLegacyUsernameToUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :legacy_username, :string, limit: 255, null: true
    add_index :spree_users, [:legacy_username, :email]
  end
end
