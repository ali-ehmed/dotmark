module StudentsHelper
	def students_sections_list(sections)
		@sections = sections
		select_tag :student_section, options_for_select(@sections.map{|section| [section.name, section.id]}), class: "form-control", prompt: "Select Section"
	end
end