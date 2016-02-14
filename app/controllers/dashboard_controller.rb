class DashboardController < ApplicationController
	include RoomReservationHelper, TimeTableSlots
  prepend_before_action :slots_data, only: [:time_table]
  
	def index
		if admin_resource
			dashbaord = "admins_dashboard"

			admins_dashboard
		elsif student_resource
			dashbaord = "students_dashboard"

			students_dashboard
		elsif teacher_resource
			dashbaord = "teachers_dashboard"

			teachers_dashboard
		end

		render action: dashbaord.to_sym
	end

	def students_dashboard
	end

	def admins_dashboard
	end

	def teachers_dashboard
		@batches = Batch.current_batches
	end

  def time_table
    render partial: 'profiles/profile_time_table'
  end

	def load_reserved_details
    attributes = ActiveSupport::JSON.decode(params.to_json)

    time_table = TimeTable.load_reserved_details(attributes["slot_id"])
    
    if attributes["section_id"]
    	time_table = time_table.where(course_allocations: { section_id: attributes["section_id"] })
    end

    if attributes["teacher_id"]
      time_table = time_table.where(course_allocations: { teacher_id: attributes["teacher_id"] })
    end

    if attributes["batch_id"]
      time_table = time_table.where(course_allocations: { batch_id: attributes["batch_id"] })
    end

    time_table = time_table.first
    
    title = ""
    content = ""

    course = time_table.course_allocation.course
    classroom = time_table.classroom
    section = time_table.course_allocation.section

    title << course.detailed_name

    if attributes["dismissible"] == "true"
      batch_id = time_table.course_allocation.batch_id

      dissmiss_options = {
        batch_id: batch_id, 
        slot_id: attributes["slot_id"], 
        course_id: course.id, 
        section_id: section.id
      }

      title << dissmiss_button(dissmiss_options)

      content << reservation_detail(classroom, section)
    else
      teacher_name = time_table.course_allocation.teacher.full_name
      content << reservation_detail(classroom, section, attributes["teacher_info"], teacher_name)
    end

    render json: { title: title.html_safe, content: content.html_safe}
  end
end