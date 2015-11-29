module Teachers
	class RegistrationsController < Devise::RegistrationsController
		def new
			@teacher = Teacher.new
			respond_with @teacher
		end

		def create
			@teacher = Teacher.new(teacher_params)
			@teacher.teacher_password = false
			respond_to do |format|
				if @teacher.save
					format.html { redirect_to teachers_path, notice: "#{@teacher.full_name} has been registered to DotMark" }
				else
					flash[:error] = "Please Review Errors:"
					format.html { render :new }
				end
			end
		end

		private

		def teacher_params
			devise_parameter_sanitizer.sanitize(:teacher)
		end
	end
end