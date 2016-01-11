# == Schema Information
#
# Table name: resource_avatars
#
#  id                 :integer          not null, primary key
#  resource_id        :integer
#  resource_type      :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  image_file_name    :string
#  image_content_type :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#

class ResourceAvatar < ActiveRecord::Base
	belongs_to :resource, polymorphic: true
	has_attached_file :image, styles: { profile: "230x230>", thumb: "100x100>" }, default_url: "user-avatar.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  # def avatar
  	
  # end
end
