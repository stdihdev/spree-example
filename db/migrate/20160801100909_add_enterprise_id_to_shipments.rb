class AddEnterpriseIdToShipments < ActiveRecord::Migration
  def change
    add_column :spree_shipments, :enterprise_id, :integer
    add_column :spree_orders, :sent_to_enterprise, :boolean, default: false

    add_index :spree_shipments, :enterprise_id
    add_index :spree_orders, [:sent_to_enterprise, :completed_at]
  end
end
