class CreateNelouSalePrices < ActiveRecord::Migration
  def change
    create_table :nelou_sale_prices do |t|
      t.integer :price_id
      t.decimal :value, scale: 2, precision: 10
      t.datetime :start_at
      t.datetime :end_at
      t.boolean :enabled

      t.timestamps null: false
    end

    add_index :nelou_sale_prices, [:price_id, :start_at, :end_at, :enabled], name: 'sale_price_price_start_end_enabled'
    add_index :nelou_sale_prices, [:start_at, :end_at, :enabled]
    add_index :nelou_sale_prices, :price_id
  end
end
