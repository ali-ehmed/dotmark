module Institutes
	class CourseAllocationsController < BaseController
		add_breadcrumb "Allocate Courses"
		def index
			@batches = Batch.current_batches
		end

		def get_allocations
			@batch = Batch.find(params[:batch_id])

			@teacher_allocations = @batch.grouped_teacher_allocation

			attributes = Array.new
			@teacher_allocations.each do |allocation|
				sections = allocation.teacher.sections_by_course(allocation.course_id).map{|m| m.section.try(:name) }

				attributes << {
					teacher: allocation.teacher.full_name,
					course: "#{allocation.course.name} - (#{allocation.course.type_name})",
					section: sections.count > 2 ? sections.join(", ") : sections.join(" & "),
					timings: content_tag(:a, "Under Approval", href: "#"),
					week_day: content_tag(:a, "Under Approval", href: "#")
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

			# this is to check if current teacher is new, if new then it is necessary to select course first
			@is_a_new_teacher = false
			if @teacher.course_allocations.present?
				@is_a_new_teacher = true
			end

			# search by teacher and batch 
			if @teacher and @batch
				# current teacher allocations
				teacher_allocations = @teacher.course_allocations.where(batch_id: @batch.id).order("course_id")
				logger.debug "Techer Allocations -> #{teacher_allocations.inspect}"

				# assigned allocations
				@already_assigned_allocations = CourseAllocation.where(:batch_id => @batch.id)
																												.where.not(teacher_id: @teacher.id).order("course_id")
			end

			# search by course
			@course = Course.find(params[:course_id]) if params[:course_id].present?
			if @course
				# current teacher allocations
				teacher_allocations = teacher_allocations.where(course_id: @course.id)
				# assigned allocations
				@already_assigned_allocations = @already_assigned_allocations.where(course_id: @course.id)

				@is_a_new_teacher = true
			end

			

			current_batch = Batch.current_batches.select {|key, hash| key['id'] == @batch.id }

			@semester = Semester.find_by_name "#{current_batch.first['semester']}"

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
				@courses.each do |course|
					course[:has_course] = true if teacher_allocations.first.course_id == course[:id]
				end

				unless @course
					teacher_allocations = teacher_allocations.where(course_id: teacher_allocations.first.course_id)
				end
				
				for teacher_allocation in teacher_allocations
					@sections.each do |section|
						section[:has_section] = true if teacher_allocation.section_id == section[:id]
					end
				end
			end

			if @already_assigned_allocations.present? and @is_a_new_teacher == true

				@courses.each do |course|
					course[:is_already_assigned] = true if @already_assigned_allocations.first.course_id == course[:id]
				end

				unless @course
					@already_assigned_allocations = @already_assigned_allocations.where(course_id: @already_assigned_allocations.first.course_id)
				end

				for assigned_allocation in @already_assigned_allocations
					@sections.each do |section|
						if assigned_allocation.section_id == section[:id]
							section[:is_already_assigned_section] = true
							section[:is_already_assigned_teacher] = assigned_allocation.teacher.full_name
						end
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
	  		format.json { render json: { status: :ok, teacher_name: @teacher.full_name } }
			end
		end

		def remove_teacher_allocations
			@teacher = Teacher.find(params[:teacher_id])
			@teacher.course_allocations.destroy_all

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
						@course = "#{allocation.course.name} - #{allocation.course.type_name}"
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