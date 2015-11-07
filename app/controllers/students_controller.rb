class StudentsController < ApplicationController
	
	def index
		cookies[:students_index] = {
		  value: '_set_student_index',
		  expires: Time.now + 1.minute,
		  domain: request.domain
		}
	end

	def dashboard	
	end
end