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

	enum :status => { finalized: 1, reserved: 0 }

	after_save :mark_all_as_final

	scope :dismiss_reservations, -> (params, teacher) {
			joins(:course_allocation)
			.where("course_allocations.course_id = ? and course_allocations.teacher_id = ? and course_allocations.batch_id = ? and course_allocations.section_id = ?",
						 params[:course_id], teacher.id, params[:batch_id], params[:section_id])
	}

	class << TimeTable
		def build_by_allocations(allocations, params)
			transaction do
				allocations = allocations.where("section_id = ? and course_id = ?", params[:section_id], params[:course_id])

				@timetable = new do |time_table|
					time_table.course_allocation_id = allocations.first.id
					time_table.classroom_id = params[:classroom_id]
					time_table.time_slot_id = params[:time_slot_id]
					time_table.save
        end

        $redis.del("count_teacher_allocations_#{params[:batch_id]}")
			end

			return true, allocations.first.course, allocations.first.section, @timetable.classroom, @timetable.time_slot_id
		end
	end

	def mark_all_as_final
		@reserved_allocations = TimeTable.joins(:course_allocation)
																		 .where("course_allocations.batch_id = ? and 
																		 				 course_allocations.course_id = ? and 
																		 				 course_allocations.teacher_id = ?",
																						 self.course_allocation.batch_id, 
																						 self.course_allocation.course_id, 
																						 self.course_allocation.teacher_id
																						 )

		@total_reserved = @reserved_allocations.where("course_allocations.section_id = ?", self.course_allocation.section_id)
																		 
		@credit_hours = self.course_allocation.course.credit_hours.to_i

		logger.debug "--------#{@reserved_allocations.length}--------"

		if @total_reserved.count == @credit_hours
      logger.debug "Finalizing"
			@total_reserved.update_all(:status => 1)
		end

	end


	private

	def default_values
		self.status = 0
	end
end
