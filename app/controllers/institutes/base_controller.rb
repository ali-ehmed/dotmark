module Institutes
	class BaseController < ApplicationController
		before_action :authenticate_admin!
		before_action -> { sidebar(true) }
		before_action -> { admin_institute_settings_aside(true) }

		add_breadcrumb "Institutes"

		def get_sections
			if params[:batch_id].blank?
				@sections = []
			else
				@batch = Batch.find(params[:batch_id])
				@sections = @batch.sections
				@new_admission = Student.enroll_new(session[:admission]) if params[:new_admission] == "true" and session[:admission]
			end
			respond_to do |format|
				format.js { render :file => "/institutes/get_sections.js.erb" }
			end
		end
	end
end
