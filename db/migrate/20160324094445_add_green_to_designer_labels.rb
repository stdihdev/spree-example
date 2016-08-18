class AddGreenToDesignerLabels < ActiveRecord::Migration
  def change
    add_column :nelou_designer_labels, :green, :boolean, null: false, default: false
  end
end
