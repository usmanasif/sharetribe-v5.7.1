class AddAttachmentImageToFeaturedSliders < ActiveRecord::Migration[5.1]
  def self.up
  	unless column_exists?(:featured_sliders, :image_file_name)
	    change_table :featured_sliders do |t|
	      t.attachment :image
	    end
  	end
  end

  def self.down
    remove_attachment :featured_sliders, :image
  end
end
