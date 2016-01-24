class RoomReservationController < ApplicationController
	prepend_before_action :time_table_slots, only: [:teacher_allocations]
	include AllocationsHelper
  respond_to :json

  def index
  end

  def search_allocations
  	allocations = $redis.get("teacher_allocations_#{current_resource}")

  	if allocations.blank?
  		@teacher_allocations = current_resource.under_approval_allocations #Only Under Approval

  		allocations = []
			@teacher_allocations.each do |allocation|

				sections = allocation.sections(allocation).order("name").collect {|m| m.try(:name) }

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
			$redis.set("teacher_allocations_#{current_resource}", allocations)
			$redis.expire("teacher_allocations_#{current_resource}", 2.minutes.to_i)
		end

		@allocs = JSON.load allocations
    
		respond_to do |format|
  		format.json { render json: { data: @allocs } }
		end
  end

  def teacher_allocations
    @batch_id = params[:batch_id]
  	@teacher_allocations = current_resource.under_approval_allocations(@batch_id)
  	respond_to do |format|
  		format.js {}
		end
  end

  def schedule_time_cell
  	@batch = Batch.find(params[:batch_id])

  	@timeslot = TimeSlot.find_by_week_day_and_start_time(params[:week_day], params[:time])
  	@count_allocations = $redis.get("count_teacher_allocations_#{@batch.id}")

  	if @count_allocations.blank?
  		@allocations = current_resource.course_allocations.under_approval.where(batch_id: @batch.id)

			pending_allocations = @allocations.pending_allocations
			logger.debug "------------#{pending_allocations.length}"
			@count_allocations = @allocations.length - pending_allocations.length

  		$redis.set("count_teacher_allocations_#{@batch.id}", @count_allocations.to_json)
      $redis.expire("count_teacher_allocations_#{@batch.id}", 30.seconds.to_i)
  	end

		@count_teacher_allocations = @count_allocations

    @teacher_allocations = current_resource.under_approval_allocations(@batch.id)

    @available_classrooms = @timeslot.available_classrooms

  	respond_to do |format|
  		format.js {}
		end
  end

  def book_room
    logger.debug "Params are :-> #{params}"

    @course_allocations = CourseAllocation.where(teacher_id: params[:teacher_id]).where(batch_id: params[:batch_id])

    result, course, section, room, slot = TimeTable.build_by_allocations @course_allocations, params

		logger.debug "Transaction: -> #{result}"

		@attributes = {
			batch_id: params[:batch_id],
			course: course,
			section: section,
			room: room,
			slot_id: slot,
			course_name: course.detailed_name
		}


		respond_to do |format|
			format.js {}
		end
	end

	def dissmiss_reserved_room
		logger.debug "Params are: -> #{params}"
		allocations = TimeTable.dismiss_reservations(params, current_resource)
		allocations.update_all("status = 0") if allocations.count > 1

		@reserved_allocation = allocations.where("time_tables.time_slot_id = ?", params[:slot_id])
		@reserved_allocation.destroy_all

		$redis.del("count_teacher_allocations_#{params[:batch_id]}")

		render :json => { status: :ok, current_domain: request.subdomain }
	end

  def time_table_slots
		@week_days = TimeSlot.week_days
		@non_fridays = TimeSlot.non_fridays
		@fridays = TimeSlot.fridays
  end
end
