# == Schema Information
#
# Table name: classrooms
#
#  id           :integer          not null, primary key
#  name         :string
#  color        :string
#  strength     :string
#  type_of_room :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Classroom < ActiveRecord::Base
	has_many :course_allocations
	validates_presence_of :name, :strength
end
