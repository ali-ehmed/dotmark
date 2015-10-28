# == Schema Information
#
# Table name: courses
#
#  id         :integer          not null, primary key
#  name       :string
#  code       :string
#  color      :string
#  batch_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Course < ActiveRecord::Base
	belongs_to :batch

	validates_presence_of :batch
end
