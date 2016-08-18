class AddCityToDesignerLabel < ActiveRecord::Migration
  def change
    add_column :nelou_designer_labels, :city, :string, limit: 255, null: true
    add_column :nelou_designer_labels, :country, :string, limit: 2, null: true
  end
end
