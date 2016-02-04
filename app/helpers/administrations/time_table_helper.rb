module Administrations::TimeTableHelper
  include RoomReservationHelper

  def rendering_time_table(params = {})
    render :layout => 'layouts/shared/time_table' do |time_table|
      html = ""
      if time_table.time_slot.booked_room_detail(params).each do |allocation|
        options =
          {
            batch_id: allocation.course_allocation.batch_id,
            course: allocation.course_allocation.course,
            section: allocation.course_allocation.section,
            room: allocation.classroom,
            slot_id: time_table.time_slot.id,
            course_name: allocation.course_allocation.course.detailed_name
          }
        html << marked_cell(options, false, true, allocation.course_allocation.teacher.full_name)
      end.empty?
        html << "---"
      end
      html.html_safe
    end
  end
end
