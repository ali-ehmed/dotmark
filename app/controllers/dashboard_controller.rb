class DashboardController < ApplicationController
	def index
		if admin_resource
			render template:  ApplicationController::Layout.admin_dashboard
		elsif student_resource
			render template:  ApplicationController::Layout.student_dashboard
		end
	end
end