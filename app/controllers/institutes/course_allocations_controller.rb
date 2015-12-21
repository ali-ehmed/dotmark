module Institutes
	class CourseAllocationsController < BaseController
		add_breadcrumb "Allocate Courses"
		def index
			@week_days = WeekDay.all
			@normal_timings = Timing.non_fridays
			@friday_timings = Timing.fridays
		end

		def get_allocation_record
			if params[:semester_name].present?
				@courses = Semester.find_by_name("#{params[:semester_name]}").try(:courses)
			end

			if params[:teacher_id].present?
				@teachers = Teacher.where("id = ?", params[:teacher_id])
			end
			respond_to do |format|
  			format.js
			end
		end
	end
end