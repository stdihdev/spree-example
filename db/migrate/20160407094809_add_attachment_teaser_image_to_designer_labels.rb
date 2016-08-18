class AddAttachmentTeaserImageToDesignerLabels < ActiveRecord::Migration
  def self.up
    change_table :nelou_designer_labels do |t|
      t.attachment :teaser_image
    end
  end

  def self.down
    remove_attachment :nelou_designer_labels, :teaser_image
  end
end
