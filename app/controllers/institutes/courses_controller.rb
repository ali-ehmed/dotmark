module Institutes
	class CoursesController < BaseController
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
	  	if @course.update_attributes(course_params)
	  		respond_to do |format|
	  			format.html { redirect_to institutes_courses_path, notice: "Course Updated" }
				end
			else
				format.html { render :edit }
				flash[:error] = @course.full_messages.to_sentence
			end
		end

		def destroy
			@course = Course.find params[:id]
			@course.destroy
			redirect_to institutes_courses_path, notice: "Course Removed Successfully"
		end

		def course_params
			params.require(:course).permit(:name, :code, :color, :semester_id)
		end
	end
end