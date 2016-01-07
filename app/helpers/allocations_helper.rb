module AllocationsHelper
	def has_courses(course)
		if course[:has_course] == true
			"checked='checked'"
		elsif course[:is_already_assigned] == true
			"checked='checked'"
		end
	end

	def remove_all_allocations(batch_id, batch_name)
		link_to "Remove All", "javascript:void(0);", onclick: "removeAllocations(this);", 
																								 data:  { batch_id: "#{batch_id}", 
																							 					  url: remove_allocations_institutes_course_allocations_path(batch_id, format: :json),
																							 					  batch_name: "#{batch_name}"
																						 					  },
																		 					   class: "btn btn-danger btn-sm pull-right"
	end

	def notification_link(teacher, batch, course)
		content_tag(:a, "Send For Approval", :href => "javascript:void(0)", 
								onclick: "sendApprovalInstructions(this, #{teacher}, #{batch}, #{course})", 
								"data-url" => notify_teacher_institutes_course_allocations_path(format: :json), 
								class: "btn btn-info btn-sm")
	end

	def teacher_allocation_options(options = {})
		html = ""
		html << "<!-- Split button -->
						<div class='btn-group'>
						  <button type='button' class='btn btn-danger'><i class='glyphicon glyphicon-trash'></i> #{options[:teacher_name]}'s Allocations</button>
						  <button type='button' class='btn btn-danger dropdown-toggle' data-toggle='dropdown' aria-haspopup='true' aria-expanded='false'>
						    <span class='caret'></span>
						    <span class='sr-only'>Toggle Dropdown</span>
						  </button>
						  <ul class='dropdown-menu dropdown-animated'>
						    <li><a href='javascript:void(0)' onclick='removeTeacherAllocations(#{options[:course_id]}, \"not_all\")'>Remove All from this course</a></li>
						    <li><a href='javascript:void(0)' onclick='removeTeacherAllocations(#{options[:course_id]}, \"all\")'>Remove All from #{options[:semester]}</a></li>
						  </ul>
						</div>"

		html.html_safe
	end
end