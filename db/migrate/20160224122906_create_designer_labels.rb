class CreateDesignerLabels < ActiveRecord::Migration
  def up
    create_table :nelou_designer_labels do |t|
      t.references :user, index: true, null: false
      t.string :name
      t.string :slug
      t.text :profile
      t.text :short_description
      t.string :photo_credits
      t.boolean :active, null: false, default: false, index: true
      t.timestamps null: false
    end

    Nelou::DesignerLabel.create_translation_table! name: :string, profile: :text, short_description: :text, slug: :string

    Spree::User.designers.find_each { |user| user.save! }
  end

  def down
    drop_table :nelou_designer_labels
    Nelou::DesignerLabel.drop_translation_table!
  end
end
