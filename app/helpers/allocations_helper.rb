module AllocationsHelper
	def has_courses(course)
		if course[:has_course] == true
			"checked='checked'"
		end
	end
end