# == Schema Information
#
# Table name: courses
#
#  id          :integer          not null, primary key
#  name        :string
#  code        :string
#  color       :string
#  semester_id :integer
#  batch_id    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Course < ActiveRecord::Base
	belongs_to :batch
	belongs_to :semester

	validates_presence_of :semester, :name, :code
end
