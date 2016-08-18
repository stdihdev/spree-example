class AddSelectionAndFeaturedToDesignerLabels < ActiveRecord::Migration
  def change
    add_column :nelou_designer_labels, :selection, :boolean, null: false, default: false
    add_column :nelou_designer_labels, :featured, :boolean, null: false, default: false

    add_index :nelou_designer_labels, [:active, :selection]
    add_index :nelou_designer_labels, [:active, :featured]
  end
end
