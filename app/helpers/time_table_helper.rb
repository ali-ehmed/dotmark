module TimeTableHelper
	def reservation_detail(room, section)
		html = ""
		html << "<table class='table table-striped'>
							<tr>
								<th align='center'>Room</th>
								<th align='center'>Section</th>
							</tr>
							<tr>
								<td>#{room.name}</td>
								<td align='center'>#{section.name}</td>
							</tr>
						</table>"

		html.html_safe
	end


	def marked_cell(batch_id, slot_id, course, section, room)
		html = ""
		# course_name = "<span class='badge pull-right'>#{course.credit_hours}</span>".html_safe
		html << "<span class=\"label\" style=\"cursor: help;background-color:#{course.color};\" data-container=\"body\" data-html=\"true\" title=\"#{course.detailed_name} <span style='margin-left:18px;'>#{dismiss_booked_room(batch_id, slot_id, course.id, section.id)}</span>\" data-toggle=\"popover\" data-placement=\"top\" data-content=\"#{reservation_detail(room, section)}\" tabindex=\"0\" data-trigger=\"focus hover\">
							#{course.code}
						</span>"

		html.html_safe
	end

	def dismiss_booked_room(*args)
		options = "{batch_id: #{args[0]}, slot_id: #{args[1]}, course_id: #{args[2]}, section_id: #{args[3]}}"
		html = ""

		html << "<button type='button' onclick='removeReservedRoom(#{options})' class='close'  aria-label='Close'>
							<span aria-hidden='true'>&times;</span>
						</button> "

		html.html_safe
	end
end
