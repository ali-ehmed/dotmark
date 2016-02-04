module Administrations::TimeTableHelper
  def rendering_time_table(params = {})
    render layout: "layouts/shared/time_table" do |time_table|
      # if @reservations.for_time_slot(time_slot.id).each do |allocation|
      html = ""
      if time_table.time_slot.time_tables.generate(params).each do |allocation|
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
    end

    html.html_safe
  end
end
