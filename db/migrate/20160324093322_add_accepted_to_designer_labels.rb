class AddAcceptedToDesignerLabels < ActiveRecord::Migration
  def change
    add_column :nelou_designer_labels, :accepted, :boolean, null: false, default: false
    add_index :nelou_designer_labels, :accepted
    add_index :nelou_designer_labels, [:active, :accepted]
  end
end
