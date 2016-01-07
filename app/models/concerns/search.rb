class Search
	class << self
		def students_search(params)
			conditions = ""
			@batch = Batch.find(params[:batch_id_param]) if params[:batch_id_param].present?
	      
	    @students = nil

	    if params[:student_name].present?
	    	conditions << "first_name || ' ' || last_name ILIKE '%#{params[:student_name]}%'"
	    end

	  	if params[:student_name].present? and params[:student_section].present?
	  		conditions << " and section_id = #{params[:student_section]}"
	  	end

	  	if params[:student_section].present?
	  		unless conditions.include?("section_id")
	  			conditions << "section_id = #{params[:student_section]}"
	  		end
	  	end

	  	if params[:roll_no].present?
	  		conditions = ""
	  		conditions << "roll_number = '#{params[:roll_no]}'"
	  	end

	  	@students = @batch.students.where(conditions)
	    @students ||= @batch.students

	    return @students, @batch
	  end

	  def teachers_search(params)
	  	conditions = ""

	  	if params[:teacher_name].present?
	  		conditions << "first_name || ' ' || last_name ILIKE '%#{params[:teacher_name]}%'"
	  		find_by_name = conditions
	  	end

	    if params[:employee_no].present?
	    	conditions = ""
    		conditions << "employee_number = '#{params[:employee_no]}'"
    		find_by_employee_number = conditions
	    end

	    @teachers = Teacher.present.where conditions

	    if params[:course_id].present?
	    	conditions = ""
	    	conditions << "course_allocations.course_id = #{params[:course_id]}"
	    	if params[:teacher_name].present?
    	 		conditions << " and " << find_by_name
    	 	elsif params[:employee_no].present?
    	 		conditions << " and " << find_by_employee_number
    	 	end

	      @teachers = @teachers.joins(:course_allocations).where(conditions).uniq
	    end

		  return @teachers
	  end
	end
end