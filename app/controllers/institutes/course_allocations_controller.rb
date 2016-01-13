module Institutes
	class CourseAllocationsController < BaseController
		add_breadcrumb "Allocate Courses"
		include AllocationsHelper

		def index
			@batches = Batch.current_batches
		end

		def get_allocations
			@batch = Batch.find(params[:batch_id])

			@teacher_allocations = @batch.grouped_teacher_allocation #All Allocations

			attributes = Array.new
			@teacher_allocations.each do |allocation|

				status = CourseAllocation.statuses[allocation.status]
				sections = allocation.sections.where("course_id = ? and teacher_id = ? and status = ?", allocation.course_id, allocation.teacher_id, status).collect {|m| m.try(:name) }

				attributes << {
					teacher: allocation.teacher.full_name,
					course: allocation.course.detailed_name,
					section: pluralize_sections(sections),
					status: allocation.alloc_statuses,
					send_instructions: notification_link(allocation.teacher_id, @batch.id, allocation.course_id)
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
			@batch_id = @batch.id
			
			# this is to check if current teacher is new, if new then it is necessary to select course first
			@is_a_new_teacher = false

			# search by teacher and batch 
			if @teacher and @batch
				# current teacher allocations
				@teacher_allocations = @teacher.course_allocations.where(batch_id: @batch.id).order("course_id")
				logger.debug "Techer Allocations -> #{@teacher_allocations.inspect}"

				# assigned allocations
				@already_assigned_allocations = CourseAllocation.where(:batch_id => @batch.id)
																												.where.not(teacher_id: @teacher.id).order("course_id")

        if @teacher.course_allocations.present?
					@is_a_new_teacher = true
				end
			end

			# search by course
			@course = Course.find(params[:course_id]) if params[:course_id].present?
			if @course
				# current teacher allocations
				@teacher_allocations = @teacher_allocations.where(course_id: @course.id) if @teacher_allocations.present?
				# assigned allocations
				@already_assigned_allocations = @already_assigned_allocations.where(course_id: @course.id) if @already_assigned_allocations.present?

				@is_a_new_teacher = true
			end

			get_current_semester() #get the current semster to load courses

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

			if @teacher_allocations.present?
				@courses.each do |course|
					course[:has_course] = true if @teacher_allocations.first.course_id == course[:id]
				end

				unless @course
					@teacher_allocations = @teacher_allocations.where(course_id: @teacher_allocations.first.course_id)
				end
				
				for teacher_allocation in @teacher_allocations
					@sections.each do |section|
						section[:has_section] = true if teacher_allocation.section_id == section[:id]
					end
				end
			end

			# taking that course which is assigned to current teacher in the current batch
			@assigned_courses = @courses.select {|key, hash| key[:has_course] == true}

			# checking if any other section is allocated to any other teacher
			# this donot include the current teacher
			if @already_assigned_allocations.present? and @is_a_new_teacher == true

				@courses.each do |course|
					course[:is_already_assigned] = true if @already_assigned_allocations.first.course_id == course[:id]
				end

				# this is checked by the "has course" value if it is not first in the list
				if @assigned_courses.present?
					@already_assigned_allocations = @already_assigned_allocations.where(course_id: @assigned_courses.first[:id])
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

			get_removal_options()
			
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

		def remove_teacher_allocations
			@teacher = Teacher.find(params[:teacher_id])
			message = ""
			message << content_tag(:strong, "#{@teacher.full_name}'s")

			if params[:type] == "all"
				@teacher_allocations = @teacher.course_allocations.where("batch_id = ?", params[:batch_id])
				message << " allocations have been removed from #{@teacher_allocations.first.batch.batch_name}"
			else
				@teacher_allocations = @teacher.course_allocations.where("course_id = ? and batch_id = ?", params[:course_id], params[:batch_id])
				message << " allocations have been removed from this course"
			end

			respond_to do |format|
				if params[:course_id].present? and params[:batch_id].present?
					@teacher_allocations.destroy_all
	  			format.json { render json: { status: :ok, msg: message } }
	  		else
	  			format.json { render json: { status: :error, msg: "Course or Batch cannot be blank." } }
	  		end
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

			@created_sections = Array.new

			@sections = attributes[:section_ids]

			render :json => { status: :error, msg: CourseAllocation::AllocationsValidity  } and return if @sections.blank? or attributes[:course_id].blank?

			@batch_id = attributes[:batch_id]

			@batch = Batch.find(@batch_id)
			@course = Course.find(attributes[:course_id])


			if attributes[:teacher_id].present?
				@teacher = Teacher.find(attributes[:teacher_id])
				teacher_allocations = @teacher.course_allocations.where("batch_id = ? and course_id = ?", @batch_id, @course.id)
			end

			course_alloc = Array.new

			old_allocations = teacher_allocations.where.not("section_id in (?)", @sections) if teacher_allocations.present?
			if old_allocations.present?
				logger.debug "Removing Old Allocations not present in #{old_allocations.inspect}"
				old_allocations.destroy_all
			end

			@created_sections << Section.where("id in (?)", @sections).order("name").map(&:name)

			for section in @sections do
				allocation = teacher_allocations.find_by_section_id(section) if teacher_allocations.present?

				if allocation.present?
					logger.debug "Present #{section}"
					next
				else
					logger.debug "Not Present #{section}"
					new_allocation = CourseAllocation.new do |allocation|
						allocation.teacher_id = attributes[:teacher_id]
						allocation.section_id = section
						allocation.batch_id = attributes[:batch_id]
						allocation.course_id = attributes[:course_id]
						allocation.semester_id = @course.semester.id
					end
				end

				course_alloc << new_allocation
			end

			CourseAllocation.transaction do
				failed = ""
				is_a_new_record = false

				if course_alloc.all?(&:valid?)
					unless teacher_allocations.present?
						is_a_new_record = true
					end
				end

				logger.debug "Total #{course_alloc.count}"

				course_alloc.reverse.each do |allocation|
					unless allocation.save
						failed = allocation
						# raise ActiveRecord::Rollback
					end
				end

				if failed.present?
					if is_a_new_record == true
						logger.debug "Removing On Failed When New Record"
						@teacher.course_allocations.where("batch_id = ? and course_id = ?", @batch_id, @course.id).destroy_all
					end

					@msg = []
					@msg << content_tag(:ul, :class => 'allocation_details_list') do
						 
					  failed.errors.full_messages.collect do |item|
					    content_tag(:li, item)
					  end.join.html_safe
					end

					render :json => { status: :error, msg: @msg  } and return
				end

				respond_to do |format|
					
					$redis.del("teacher_allocations")
					get_current_semester()
					get_removal_options[:course_id] = @course.id

					format.js {}
				end
			end
		end

		def notify_teacher_for_approval
			@teacher = Teacher.find(params[:teacher_id].to_i)
			CourseAllocation.send_for_approval(@teacher, params[:batch_id].to_i, params[:course_id].to_i)

			render :json => { status: :ok, msg: CourseAllocation::Approval  } and return
		end

		private

		def get_current_semester

			current_batch = Batch.current_batches.select {|key, hash| key['id'] == @batch_id.to_i }
			@semester = Semester.find_by_name "#{current_batch.first['semester']}"

			@semester
		end

		def get_removal_options
			@teacher_allocations_for_removal = nil
			if @course.present?
				course_id = @course.id

				@teacher_allocations_for_removal = @teacher_allocations
			else 
			  if @assigned_courses.present?
					course_id = @assigned_courses.first[:id]
					@teacher_allocations_for_removal = @teacher_allocations.where(course_id: course_id)
				else
					course_id = ""
				end
			end

			if @teacher and @batch
				@options = {
					teacher_name: @teacher.full_name,
					course_id: course_id,
					batch: @batch.name,
					semester: @semester.name
				}
			end

			@options
		end

		def allocation_params
			params.require(:course_allocation).permit(:status)
		end
	end
end