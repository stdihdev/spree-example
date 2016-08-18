class AddCountryCodeToSpreeOptionTypes < ActiveRecord::Migration
  def change
    add_column :spree_option_types, :country_code, :string, index: true, limit: 2, null: true
  end
end
