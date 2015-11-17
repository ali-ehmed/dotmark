# == Schema Information
#
# Table name: notifications
#
#  id            :integer          not null, primary key
#  body          :string
#  resource_type :string
#  resource_id   :integer
#  sent_at       :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Notification < ActiveRecord::Base
	belongs_to :resource, polymorphic: true
end
