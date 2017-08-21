class XquicHomepageController < ApplicationController
	
	before_action :save_current_path, :except => :sign_in
	layout "index"

	def home
		@categories = @current_community.categories.includes(:children)
		@main_categories = @categories.select { |c| c.parent_id == nil }
		@listings = Listing.where featured: true
		@first_slider_images = FeaturedSlider.where image_for: 1
		@second_slider_images = FeaturedSlider.where image_for: 2
		@third_slider_images = FeaturedSlider.where image_for: 3
		return "home", layout: "index"
	end

end