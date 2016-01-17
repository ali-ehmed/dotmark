# == Schema Information
#
# Table name: time_slots
#
#  id         :integer          not null, primary key
#  week_day   :string
#  start_time :datetime
#  end_time   :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class TimeSlot < ActiveRecord::Base
	has_many :time_tables

	has_many :course_allocations, through: :time_tables
	has_many :classrooms, through: :time_tables

	def available_classrooms
		if classrooms.blank?
			Classroom.all
		else
			Classroom.where.not("id in (?)", classrooms.map(&:id))
		end
	end

	scope :non_fridays, -> { select("start_time, end_time").where.not(week_day: "Friday").group("start_time, end_time").order("start_time") }

	scope :fridays, -> { select("start_time, end_time").where(week_day: "Friday").group("start_time, end_time").order("start_time") }

	scope :week_days, -> { select("week_day").group("week_day")
												.order("CASE week_day 
																	WHEN 'Monday' 
																	THEN 1 
																	WHEN 'Tuesday' 
																	THEN 2 
																	WHEN 'Wednesday' 
																	THEN 3 
																	WHEN 'Thursday' 
																	THEN 4 
																END") 
											}
	scope :for, -> (week_day) { where(week_day: week_day) }

	def timings
		"#{start_time.strftime("%I:%M")} - #{end_time.strftime("%I:%M")}"
	end
end
