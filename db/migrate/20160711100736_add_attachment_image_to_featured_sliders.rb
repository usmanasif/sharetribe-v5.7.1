class AddAttachmentImageToFeaturedSliders < ActiveRecord::Migration
  def self.up
    change_table :featured_sliders do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :featured_sliders, :image
  end
end
