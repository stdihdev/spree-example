class AddInvoicePathToOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :invoice_path, :string
  end
end
