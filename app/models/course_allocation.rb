# == Schema Information
#
# Table name: course_allocations
#
#  id           :integer          not null, primary key
#  course_id    :integer
#  teacher_id   :integer
#  batch_id     :integer
#  timings      :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  section_id   :integer
#  semester_id  :integer
#  time_slot_id :integer
#  classroom_id :integer
#  status       :integer          default(0)
#

class CourseAllocation < ActiveRecord::Base
	belongs_to :course
	belongs_to :teacher
	belongs_to :batch
	belongs_to :section
	belongs_to :semester

	has_many :time_tables

	validates :course_id, :teacher_id, :section_id, :batch_id, presence: true, on: :create
	validate :perform_restrictions!

	include ActionView::Helpers::TagHelper
	include AllocationsHelper

	enum status: { archived: 0, under_approval: 1, approved: 2 }

	scope :pending_allocations, -> { joins(:time_tables).where("time_tables.status = 1").select("time_tables.status, section_id, course_id").group("time_tables.status, section_id, course_id") }

	ALLOCATIONS_VALIDITY = "Please Select Course and Sections"
	APPROVAL = "Notification has been sent successfully."
	
	class << self
		def build_transaction(&block)
			CourseAllocation.transaction do 
				yield
			end
		end

		# check on the same slot if batch's section has been already assigned to another teacher
		def reserved_allocation?(allocation, section)
			reservation = TimeTable.joins(:course_allocation)
														 .where("course_allocations.course_id = ? and course_allocations.teacher_id = ? and course_allocations.batch_id = ? and course_allocations.section_id = ?",
														 	       allocation.course_id, allocation.teacher_id, allocation.batch_id, section.id)
			unless reservation.blank?
				return true if reservation.first.reserved?
				return false if reservation.first.finalized?
			end

			true
		end

		def send_for_approval(teacher, batch_id, course_id)
			allocations = teacher.allocations(batch_id, course_id)
			allocations.update_all("status = 1")
			$redis.del("count_teacher_allocations_#{batch_id}")
			NotificationMailer.send_allocation_instructions(teacher, allocations).deliver_now!
		end
	end

	def sections(allocation)
		status = CourseAllocation.statuses[allocation.status]
		Section.allocated.where("course_id = ? and teacher_id = ? and status = ?", allocation.course_id, allocation.teacher_id, status)
	end

	def alloc_statuses
		editable_status(self)
	end

	# performing validations

	def perform_restrictions!
		if self.teacher_id and self.batch_id and self.course_id
			@teacher = Teacher.find(self.teacher_id)
			batch_id = self.batch_id
			course_id = self.course_id

			allocations = CourseAllocation.where("batch_id = ? and course_id = ?", batch_id, course_id)
			
			# This Code has now handled through Javascript
			assigned_allocations_count = self.batch.sections.count - allocations.count
			if assigned_allocations_count == 0
				errors.add(:base, "This Course is allocated for all the sections.".html_safe)
				return
			end

			# Not to assign more than three sections of any course to any teacher
			teacher_allocations = @teacher.course_allocations.where("batch_id = ? and course_id = ?", batch_id, course_id)

			if teacher_allocations.count == 3
				errors.add(:base, "'#{content_tag(:strong, @teacher.full_name)}' cannot be assigned to more than 3 sections for #{content_tag(:strong, self.batch.batch_name)}".html_safe)
			end

			# Not to assign more than two course in any batch to any teacher
			unless teacher_allocations.present?
				course_allocations = @teacher.course_allocations.where("course_allocations.batch_id = ?", batch_id)
																												.joins(:course).where("courses.lab = false or courses.lab = true")
																												.select("course_allocations.course_id")
																												.group("course_allocations.course_id")

				if course_allocations.length >= 2
					errors.add(:base, "'#{content_tag(:strong, @teacher.full_name)}' can only be assign to 1 Lab and 1 Theory of any course in this Batch.".html_safe)
				end
			end
		end
	end
end
