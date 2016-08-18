class AddTypeToSpreeOptionValue < ActiveRecord::Migration
  def change
    add_column :spree_option_values, :type, :string, index: true, null: true
    add_column :spree_option_types, :type, :string, index: true, null: true

    add_index :spree_option_values, [:option_type_id, :type]
  end
end
