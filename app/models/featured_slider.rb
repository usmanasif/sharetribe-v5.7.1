# == Schema Information
#
# Table name: featured_sliders
#
#  id                 :integer          not null, primary key
#  listing_id         :integer
#  is_active          :boolean
#  image_for          :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#

class FeaturedSlider < ActiveRecord::Base
  belongs_to :listing
  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: 'images/index/No_image_available.png'
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  
  def image_status
    self.image_for
  end

end
