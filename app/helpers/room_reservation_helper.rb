module RoomReservationHelper
	def reservation_detail(room, section, teacher_info = false, teacher_name = "")
		html = ""
		teacher_info_header = ""
		teacher_info_body = ""

		if teacher_info == "true" and teacher_name.present?
			teacher_info_header << "<th align='center'>Teacher</th>".html_safe
			teacher_info_body << "<td align='center'>#{teacher_name}</td>".html_safe
		end

		html << "<table class='table table-striped'>
							<tr>
								<th align='center'>Room</th>
								<th align='center'>Section</th>
								#{teacher_info_header}
							</tr>
							<tr>
								<td>#{room.name}</td>
								<td align='center'>#{section.name}</td>
								#{teacher_info_body}
							</tr>
						</table>"

		html.html_safe
	end

	def dissmiss_button(parameters)
		dismiss_btn = ""

		parameters = Array.new << parameters.to_json
		dismiss_btn << "#{dismiss_booked_room(parameters)}"

		dismiss_btn.html_safe
	end

	# Teacher Info is false by default because it is used in teachers profile however for admin, it can be true
	def marked_cell(time_table, dismissible = true, teacher_info = false)
		html = ""
		popover = ""
		span_attr = ""

		params_hash = Hash.new
		params_hash[:slot_id] = time_table.time_slot_id
		params_hash[:teacher_info] = teacher_info
		params_hash[:dismissible] = dismissible

		if teacher_signed_in?
			params_hash[:teacher_id] = time_table.course_allocation.teacher_id
		end

		behavior = Array.new << params_hash.to_json

		# Object of params to remove reserved room
		course = time_table.course_allocation.course

		span_attr << "class=\"book-reserved-detail label\" "
		span_attr << "style=\"cursor: help;background-color:#{course.color};\" "
		span_attr << "data-behavior='#{behavior}' "
		span_attr << "data-url=\"#{load_details_path}\" "

		popover << "data-container=\"body\" "
		popover << "data-html=\"true\" "
		popover << "title=\"\" "
		popover << "data-placement=\"top\" "
		popover << "data-content=\"\" tabindex=\"0\" "
		popover << "data-trigger=\"click hover\""

		html << "<span #{popover.html_safe} #{span_attr.html_safe}>
							#{course.code}
						</span>"

		html.html_safe
	end

	def dismiss_booked_room(*args)
		html = ""

		html << "<button type='button' style='margin-top:-3px;' data-params='#{args[0]}' onclick='window.$timetable.removeReservedRoom(this);' class='close pull-right'  aria-label='Close'>
							<span aria-hidden='true'>&times;</span>
						</button> "

		html.html_safe
	end
end
