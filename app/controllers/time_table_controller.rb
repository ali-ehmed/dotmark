class TimeTableController < ApplicationController
  def index
  end

  def search_allocations

  	allocations = $redis.get("teacher_allocations")
  	if allocations.blank?
  		@teacher_allocations = current_resource.grouped_allocations

  		allocations = []
			@teacher_allocations.each do |allocation|
				sections = allocation.teacher.sections_by_course(allocation.course_id).map{|m| m.section.try(:name) }
				allocations << {
					course: allocation.course.name,
					course_type: allocation.course.type_name,
					section: sections.count > 2 ? sections.join(", ") : sections.join(" & "),
					batch: allocation.batch.name,
					semester: allocation.semester.try(:name),
					sent_date: "---"
				}
			end
			allocations = allocations.to_json
			$redis.set("teacher_allocations", allocations)
			$redis.expire("teacher_allocations", 2.minutes.to_i)
		end

		@allocs = JSON.load allocations
		respond_to do |format|
  		format.json { render json: { data: @allocs } }
		end
  end

  def schedule_time_cell
  	@week_day = TimeSlot.find_by_week_day_and_start_time(params[:week_day], params[:time])
  	respond_to do |format|
  		format.js {}
		end
  end
end
