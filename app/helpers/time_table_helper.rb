module TimeTableHelper
	def reservation_detail(course, section)
		html = ""
		html << "<ul class='list-inline'>
							<li>
								Section #{section.name}
							</li>
							<li>
								<span class='badge'>#{course.credit_hours}</span>
							</li>
						</ul>"

		html.html_safe
	end
end
