module Institutes
	class CourseAllocationsController < BaseController
		add_breadcrumb "Allocate Courses"
		def index
			@batches = Batch.batches_running_currently
		end

		def get_allocations
			@batch = Batch.find(params[:batch_id])
			@allocations = @batch.course_allocations
			attributes = Array.new
			@allocations.each do |allocation|
				attributes << {
					teacher: allocation.teacher.full_name,
					course: allocation.course.name,
					section: allocation.section.try(:name),
					timings: allocation.class_timing.blank? ? content_tag(:a, "Under Approval", href: "#") : allocation.class_timing.timings,
					week_day: allocation.week_day.blank? ? content_tag(:a, "Under Approval", href: "#") : allocation.week_day.name
				}
			end

			respond_to do |format|
	  		format.json { render json: { data: attributes } }
			end
		end

		def courses_and_sections
			@teacher = Teacher.find(params[:teacher_id]) unless params[:teacher_id].blank?

			return if params[:batch_id].blank?

			@batch = Batch.find(params[:batch_id])

			if @teacher and @batch
				teacher_allocations = @teacher.course_allocations.where(batch_id: @batch.id)
				logger.debug "Techer Allocations -> #{teacher_allocations.count}"
			end

			current_batch = Batch.batches_running_currently.select {|key, hash| key[:id] == @batch.id }

			@semester = Semester.find_by_name "#{current_batch.first[:semester]}"

			@courses = Array.new
			course_attributes = Hash.new
			@semester.courses.each do |course|
				course_attributes = {
					id: course.id,
					name: course.name,
					course_code: course.code,
					semester: course.semester.name,
					batch: @batch.name,
					course_type: course.type_name,
					has_course: false
				}

				@courses << course_attributes
			end

			@sections = Array.new
			section_attributes = Hash.new
			@batch.sections.each do |section|
				section_attributes = {
					id: section.id,
					name: section.name,
					has_section: false
				}

				@sections << section_attributes
			end

			if teacher_allocations.present?
				for teacher_allocation in teacher_allocations
					@courses.each do |course|
						course[:has_course] = true if teacher_allocation.course_id == course[:id]
					end

					@sections.each do |section|
						section[:has_section] = true if teacher_allocation.section_id == section[:id]
					end
				end
			end

			logger.debug "Sections: -> #{@sections.inspect}"
			logger.debug "Courses -> #{@courses.inspect}"
			respond_to do |format|
				format.js {}
			end
		end

		def remove_allocations
			@batch = Batch.find(params[:batch_id])
			@allocations = @batch.course_allocations
			@allocations.destroy_all if @allocations.present?

			respond_to do |format|
	  		format.json { render json: { status: :ok } }
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
				render :json => { status: :error, msg: CourseAllocation::SectionsValidity  } and return if @sections.blank?

				if attributes[:teacher_id].present?
					teacher = Teacher.find(attributes[:teacher_id])
					allocations = teacher.has_courses(attributes[:batch_id], attributes[:course_id])
					if allocations.present?
						logger.debug "--Removing old allocations--"
						allocations.destroy_all
					end
				end

				
				for section in @sections do
					allocation = CourseAllocation.new
					allocation.teacher_id = attributes[:teacher_id]
					allocation.section_id = section
					allocation.batch_id = attributes[:batch_id]
					allocation.course_id = attributes[:course_id]
					unless allocation.save
						@msg = []
						
						@msg << content_tag(:ul, :class => 'allocation_details_list') do
							 
						  allocation.errors.full_messages.collect do |item|
						    content_tag(:li, item)
						  end.join.html_safe
						end
						# .map { |msg| content_tag(:li, msg) }.join
						render :json => { status: :error, msg: @msg  } and return
					else
						@teacher_name = allocation.teacher.full_name
						@course = allocation.course.name
						@batch = allocation.batch.name
						@msg << Section.find(section).name
					end
				end
				render :json => { status: :created, 
													batch: @batch, 
													teacher_name: @teacher_name,
													batch_id: attributes[:batch_id], 
													course: @course, 
													sections: @msg  }
			end
		end
	end
end