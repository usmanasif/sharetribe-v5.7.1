class CreateFeaturedSliders < ActiveRecord::Migration[5.1]
  def change
  	unless table_exists?(:featured_sliders)
	    create_table :featured_sliders do |t|
	      t.integer :listing_id
	      t.boolean :is_active
	      t.integer :image_for
	      t.timestamps null: false
	    end
	  end
  end
end