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

	before_create :default_values

	enum :status => { final: 1, reserved: 0 }

	after_save :mark_all_as_final

	class << TimeTable
		def build_by_allocations(allocations, params)
			transaction do
				@course_id = params["course_id_#{params[:section_id]}"]
				allocations = allocations.where("section_id = ? and course_id = ?", params[:section_id], @course_id)

				@timetable = new do |time_table|
					time_table.course_allocation_id = allocations.first.id
					time_table.classroom_id = params[:classroom_id]
					time_table.time_slot_id = params[:time_slot_id]
					time_table.save
				end
			end
		end
	end

	def mark_all_as_final
		@reserved_allocations = TimeTable.joins(:course_allocation)
																		 .where("course_allocations.batch_id = ? and 
																		 				 course_allocations.course_id = ? and 
																		 				 course_allocations.teacher_id = ? and 
																		 				 course_allocations.section_id = ?", 
																						 self.course_allocation.batch_id, 
																						 self.course_allocation.course_id, 
																						 self.course_allocation.teacher_id, 
																						 self.course_allocation.section_id
																						 )
																		 
		@credit_hours = self.course_allocation.course.credit_hours.to_i

		logger.debug "--------#{@reserved_allocations.count}--------"

		if @reserved_allocations.count == @credit_hours
			@reserved_allocations.update_all(:status => 1)
		end

	end


	private

	def default_values
		self.status = 0
	end
end
