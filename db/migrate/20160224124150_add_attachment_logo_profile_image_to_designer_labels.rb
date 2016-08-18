class AddAttachmentLogoProfileImageToDesignerLabels < ActiveRecord::Migration
  def self.up
    change_table :nelou_designer_labels do |t|
      t.attachment :logo
      t.attachment :profile_image
    end
  end

  def self.down
    remove_attachment :nelou_designer_labels, :logo
    remove_attachment :nelou_designer_labels, :profile_image
  end
end
