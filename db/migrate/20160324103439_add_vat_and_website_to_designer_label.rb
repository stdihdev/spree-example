class AddVatAndWebsiteToDesignerLabel < ActiveRecord::Migration
  def change
    add_column :nelou_designer_labels, :vat, :string, null: true, limit: 50
    add_column :nelou_designer_labels, :website, :string, null: true, limit: 255
    add_column :nelou_designer_labels, :paypal, :string, null: true, limit: 255
  end
end
