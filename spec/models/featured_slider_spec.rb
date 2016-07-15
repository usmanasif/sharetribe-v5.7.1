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

require 'rails_helper'

RSpec.describe FeaturedSlider, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
