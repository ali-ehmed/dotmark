module Institutes
	class CourseAllocationsController < BaseController
		add_breadcrumb "Allocate Courses"
		def index
			@week_days = WeekDay.all
			@batches = Batch.current_batches
			@teachers = Teacher.all
			@semesters = Semester.all
		end

		def get_courses_by_batch
			@batch = Batch.current_batches.select{|key, hash| key[:id] == params[:batch_id].to_i }
			@semester = Semester.find_by_name "#{@batch.first[:semester]}"
			respond_to do |format|
  			format.js
			end
		end

		def allocate
			logger.debug "Params are: #{params.inspect}"
			attributes = {
				teacher_id: params[:teacher_id],
				course_id: params[:course_id],
				section_ids: params[:section_ids].try(:keys),
				batch_id: params[:batch_id]
			}

			@sections = attributes[:section_ids]
			@msg = Array.new

			CourseAllocation.build_allocation do 
				render :json => { status: :error, msg: "Please select Sections"  } and return if @sections.blank?
				for section in @sections do
					allocation = CourseAllocation.new
					allocation.teacher_id = attributes[:teacher_id]
					allocation.section_id = section
					allocation.batch_id = attributes[:batch_id]
					allocation.course_id = attributes[:course_id]
					unless allocation.save
						@msg << allocation.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
						render :json => { status: :error, msg: @msg  } and return
					else
						@teacher_name = allocation.teacher.full_name
						@course = allocation.course.name
						@batch = allocation.batch.name
						@msg << Section.find(section).name
					end
				end
				render :json => { status: :created, batch: @batch, teacher_name: @teacher_name, course: @course, sections: @msg  }
			end
		end
	end
end