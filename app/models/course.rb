# == Schema Information
#
# Table name: courses
#
#  id           :integer          not null, primary key
#  name         :string
#  code         :string
#  color        :string
#  semester_id  :integer
#  batch_id     :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  credit_hours :string
#  lab          :boolean
#

class Course < ActiveRecord::Base
	belongs_to :batch
	belongs_to :semester

	validates_presence_of :semester, :name, :code

	has_many :teachers
	has_many :teachers, through: :course_allocations
end
