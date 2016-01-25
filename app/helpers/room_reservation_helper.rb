module RoomReservationHelper
	def reservation_detail(room, section, teacher_info = false, teacher_name = "")
		html = ""
		teacher_info_header = ""
		teacher_info_body = ""
		if teacher_info == true and teacher_name.present?
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
								<td>#{room[:name]}</td>
								<td align='center'>#{section[:name]}</td>
								#{teacher_info_body}
							</tr>
						</table>"

		html.html_safe
	end

	# Teacher Info is false by default because it is used in teachers profile however for admin, it can be true
	def marked_cell(options = {}, dismissible = true, teacher_info = false, teacher = "")
		html = ""
		dismiss_btn = ""
		
		# Object of params to remove reserved room
		dismiss_btn << "#{dismiss_booked_room(options[:batch_id], options[:slot_id], options[:course][:id], options[:section][:id])}".html_safe if dismissible == true

		html << "<span class=\"label\" style=\"cursor: help;background-color:#{options[:course][:color]};\" data-container=\"body\" data-html=\"true\" title=\"#{options[:course_name]} #{dismiss_btn}\" data-toggle=\"popover\" data-placement=\"top\" data-content=\"#{reservation_detail(options[:room], options[:section], teacher_info, teacher)}\" tabindex=\"0\" data-trigger=\"focus hover\">
							#{options[:course][:code]}
						</span>"

		html.html_safe
	end

	def dismiss_booked_room(*args)
		options = "{batch_id: #{args[0]}, slot_id: #{args[1]}, course_id: #{args[2]}, section_id: #{args[3]}}"
		html = ""

		html << "<button type='button' style='margin-top:-3px;' onclick='removeReservedRoom(#{options})' class='close pull-right'  aria-label='Close'>
							<span aria-hidden='true'>&times;</span>
						</button> "

		html.html_safe
	end
end
