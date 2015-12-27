module Institutes
	class CoursesController < BaseController
		add_breadcrumb "Courses"
		# respond_to :js, only: [:get_course_by_section]

		def index
			@semesters = Semester.all
			# @semester = @semesters.first_semester
			@course = Course.new
		end

		def create
			course = Course.new(course_params)
	  	if course.save
	  		respond_to do |format|
	  			@semesters = Semester.all
	  			format.js
				end
			else
				render json: { status: :error, errors: "#{course.errors.full_messages.map { |msg| content_tag(:li, msg) }.join}" }, status: :created
			end
		end

		def edit
			@course = Course.find(params[:id])
		end

		def update
			@course = Course.find(params[:id])
			respond_to do |format|
				if @course.update(course_params)
	        # format.json { respond_with_bip(@course) }
	        format.json { render :json => { status: :created, color: @course.color } }
	      else
	        format.json { respond_with_bip(@course) }
	      end
	    end
		end

		def destroy
			@course = Course.find params[:id]
			@course.destroy
			redirect_to institutes_courses_path, notice: "Course Removed Successfully"
		end

		def course_params
			params.require(:course).permit(:name, :code, :color, :semester_id, :course_type)
		end
	end
end