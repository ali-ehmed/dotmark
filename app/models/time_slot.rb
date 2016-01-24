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
		if self.classrooms.blank?
			Classroom.all
		else
			Classroom.where.not("id in (?)", self.classrooms.map(&:id))
		end
	end

	def class_going_on?(batch, section)
		going_on = self.time_tables.joins(:course_allocation).where("course_allocations.batch_id = ? and course_allocations.section_id = ?", batch, section)
		if going_on.present?
			{:teacher => going_on.first.course_allocation.teacher.full_name, :classroom => going_on.first.classroom.name }
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
