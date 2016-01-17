# == Schema Information
#
# Table name: time_tables
#
#  id                   :integer          not null, primary key
#  time_slot_id         :integer
#  classroom_id         :integer
#  course_allocation_id :integer
#  status               :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class TimeTable < ActiveRecord::Base
	belongs_to :time_slot
	belongs_to :classroom
	belongs_to :course_allocation
end
