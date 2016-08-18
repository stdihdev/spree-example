class AddGenderToAddresses < ActiveRecord::Migration
  def change
    add_column :spree_addresses, :gender, :string, null: true
  end
end
