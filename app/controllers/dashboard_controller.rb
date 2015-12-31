class DashboardController < ApplicationController
	def index
		if admin_resource
			dashbaord = "admins_dashboard"
		elsif student_resource
			dashbaord = "students_dashboard"
		elsif teacher_resource
			dashbaord = "teachers_dashboard"
		end

		render action: dashbaord.to_sym
	end

	def students_dashboard
		
	end

	def admins_dashboard
		
	end

	def teachers_dashboard
		
	end
end