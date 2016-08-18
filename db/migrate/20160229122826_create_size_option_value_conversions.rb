class CreateSizeOptionValueConversions < ActiveRecord::Migration
  def change
    create_table :nelou_size_option_value_conversions, id: false do |t|
      t.integer :size_option_value_id
      t.integer :alias_id
    end

    add_index :nelou_size_option_value_conversions, [:size_option_value_id, :alias_id], unique: true, name: :size_option_size_option_alias # Because the generate name is too long
    add_index :nelou_size_option_value_conversions, [:alias_id, :size_option_value_id], unique: true, name: :size_option_alias_size_option # Because the generate name is too long
  end
end
