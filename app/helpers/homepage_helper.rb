module HomepageHelper
  def show_subcategory_list(category, current_category_id)
    category.id == current_category_id || category.children.any? do |child_category|
      child_category.id == current_category_id
    end
  end

  def with_first_listing_image(listing, &block)
    Maybe(listing)
      .listing_images
      .map { |images| images.first }[:small_3x2].each { |url|
      block.call(url)
    }
  end

  def without_listing_image(listing, &block)
    if listing.listing_images.size == 0
      block.call
    end
  end

  def format_distance(distance)
    precision = (distance < 1) ? 1 : 2
    (distance < 0.1) ? "< #{number_with_delimiter(0.1, locale: locale)}" : number_with_precision(distance, precision: precision, significant: true, locale: locale)
  end
  
    def get_image_url listing
    array = []
    Listing.find(listing.id).listing_images.each_with_index do |list , i|
      array << list.image.url(:original)
    end
    return array
  end

  def listing_image_url(listing , which_one)
    url = '/assets/add_more_images.jpg'
    if temp = Listing.find(listing['id']).listing_images[which_one]
      url = temp.image.url(:original)
    end
    return url  
  end

  def set_path listing_id
    Listing.find listing_id    
  end

  def is_featured id
    return Listing.find(id.to_i).featured
  end
end