class TimeTableController < ApplicationController
	prepend_before_action :time_table_slots, only: [:teacher_allocations]
	include AllocationsHelper

  def index
  end

  def search_allocations
  	allocations = $redis.get("teacher_allocations")

  	if allocations.blank?
  		@teacher_allocations = current_resource.under_approval_allocations #Only Under Approval

  		allocations = []
			@teacher_allocations.each do |allocation|

				sections = allocation.sections(allocation).collect {|m| m.try(:name) }

				allocations << {
					course: allocation.course.name,
					course_type: allocation.course.type_name,
					section: pluralize_sections(sections),
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

  def teacher_allocations
  	@teacher_allocations = current_resource.under_approval_allocations(params[:batch_id])
  	respond_to do |format|
  		format.js {}
		end
  end

  def schedule_time_cell
  	@batch = Batch.find(params[:batch_id])

  	@week_day = TimeSlot.find_by_week_day_and_start_time(params[:week_day], params[:time])
  	@count_allocations = $redis.get("count_teacher_allocations_#{@batch.id}")

  	if @count_allocations.blank?
  		@count_allocations = current_resource.course_allocations.under_approval.where(batch_id: @batch.id).count.to_json
  		$redis.set("count_teacher_allocations_#{@batch.id}", @count_allocations)
      $redis.expire("count_teacher_allocations_#{@batch.id}", 1.second.to_i)
  	end

		@count_teacher_allocations = JSON.load @count_allocations

    @teacher_allocations = current_resource.under_approval_allocations(@batch.id)

  	respond_to do |format|
  		format.js {}
		end
  end

  def time_table_slots
		@week_days = TimeSlot.week_days
		@non_fridays = TimeSlot.non_fridays
		@fridays = TimeSlot.fridays
  end
end
