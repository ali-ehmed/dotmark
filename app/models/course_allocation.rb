# == Schema Information
#
# Table name: course_allocations
#
#  id              :integer          not null, primary key
#  course_id       :integer
#  teacher_id      :integer
#  batch_id        :integer
#  timings         :string
#  class_timing_id :integer
#  week_day_id     :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  section_id      :integer
#

class CourseAllocation < ActiveRecord::Base
	belongs_to :course
	belongs_to :teacher
	belongs_to :batch
	belongs_to :section
	belongs_to :class_timing, class_name: "Timing", foreign_key: :class_timing_id
	belongs_to :week_day

	validates :course_id, :teacher_id, :section_id, :batch_id, presence: true, on: :create
	validate :restrict_allocations

	include ActionView::Helpers::TagHelper

	SectionsValidity = "Please select Sections"
	def self.build_allocation(&block)
		CourseAllocation.transaction do 
			yield
		end
	end

	def restrict_allocations
		if self.teacher_id and self.batch_id and self.course_id
			teacher = Teacher.find(self.teacher_id)
			batch_id = self.batch_id
			course_id = self.course_id

			allocations = CourseAllocation.where("batch_id = ? and course_id = ?", batch_id, course_id)

			for assigned_allocation in allocations do
				if assigned_allocation.section_id == self.section_id
					teacher_allocations = allocations.select("teacher_id").group("teacher_id")
					errors.add(:base, "<span>\"Allocations already assigned\"</span>".html_safe)

					teacher_allocations.each do |t_allocation|
						unless t_allocation.teacher_id == self.teacher_id
							sections = t_allocation.teacher.has_courses(assigned_allocation.batch_id, assigned_allocation.course_id).map{|m| m.section.try(:name) }.join(", ")
							errors.add(:base, "#{content_tag(:strong, t_allocation.teacher.full_name)} is assigned for sections #{sections}".html_safe)	
						end
					end
				end
			end

			
			assigned_allocations_count = self.batch.sections.count - allocations.count
			if assigned_allocations_count == 0
				errors.add(:base, "This Course is allocated for all the sections.".html_safe)
				return
			end

			if teacher.has_courses(self.batch_id, self.course_id).count == 3
				errors.add(:base, "'#{content_tag(:strong, teacher.full_name)}' cannot be assigned <br /> to more than 3 sections for #{content_tag(:strong, self.batch.batch_name)}".html_safe)
			end
		end
	end
end
