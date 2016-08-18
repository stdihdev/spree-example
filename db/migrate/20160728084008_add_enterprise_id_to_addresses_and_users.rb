class AddEnterpriseIdToAddressesAndUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :enterprise_partner_id, :integer
    add_column :spree_users, :enterprise_contact_id, :integer
    add_column :spree_addresses, :enterprise_id, :integer

    add_index :spree_users, :enterprise_partner_id
    add_index :spree_users, :enterprise_contact_id
    add_index :spree_addresses, :enterprise_id
  end
end
