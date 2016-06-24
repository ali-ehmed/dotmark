module Administrations
	class AdmissionsController < ApplicationController
		before_action :get_new_admission_sections, only: [:new, :create]

		def setup_admission
	  	admission_params_hash = {
				:section => params[:section],
				:batch => params[:batch],
	      :semester => params[:semester]
	  	}
 	
	  	@admission = Student.build_admission(admission_params_hash)

	  	@batch_name = Batch.find(@admission.batch_id).batch_name if params[:batch].present?

	    respond_to do |format|
	    	if @admission.valid? == true
	        session[:admission] = @admission
	    		format.json { render :json => { status: :ok, redirect_url: new_student_path(@batch_name) }, status: :created }
	  		else
					format.json { render :json => { status: :error, errors: @admission.errors.full_messages.map { |msg| content_tag(:li, msg) }.join }, status: :created }
	  		end
	    end
	  end

		def cancel_admission
			session[:admission] = nil
			redirect_to students_path
			flash[:notice] = "Admission Cancelled"
		end

		def autocomplete_guardians_search
			@guardian_names = Parent.all.collect do |parent|  {
	        :id => parent.id,
	        :name => parent.name
	      }
	    end.to_json

			respond_to do |format|
				format.json { render :json => @guardian_names }
			end
		end

		def get_parent
			@parent = Parent.find(params[:parent_id]) if params[:parent_id]
			respond_to do |format|
				format.js
			end
		end

		private

		def get_new_admission_sections
			@admission_sections = Batch.find(session[:admission]["batch_id"]).sections
		end
	end
end