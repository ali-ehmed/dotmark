module Administrations::TimeTableHelper
  include RoomReservationHelper

  def rendering_time_table(params = {})
    render :layout => 'layouts/shared/time_table' do |time_table|
      html = ""
      if time_table.time_slot.booked_room_detail(params).each do |allocation|
        html << marked_cell(allocation, false, true)
      end.empty?
        html << "---"
      end
      html.html_safe
    end
  end

  def profile_time_popover_title(slot)
    return "Classes on #{slot.week_day}, #{slot.timings}"
  end

  def profile_time_popover_content(teacher, slot)
    render :partial => 'layouts/shared/teacher_dashboard_slot_detail', locals: { teacher: teacher, slot: slot }  
  end
end
