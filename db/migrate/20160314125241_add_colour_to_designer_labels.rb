class AddColourToDesignerLabels < ActiveRecord::Migration
  def change
    add_column :nelou_designer_labels, :background_colour, :string, limit: 7, null: false, default: '#8d93a3'
  end
end
