class AddIbanBicToDesignerLabels < ActiveRecord::Migration
  def change
    add_column :nelou_designer_labels, :iban, :string, null: true, limit: 100
    add_column :nelou_designer_labels, :bic, :string, null: true, limit: 100
  end
end
