module Students
	class RegistrationsController < Devise::RegistrationsController
		before_action :get_new_admission_sections, only: [:new, :create]

		def setup_admission
	  	admission_params_hash = {
				:section => params[:section],
				:batch => params[:batch],
	      :semester => params[:semester]
	  	}

	  	
	  	@admission = Student.build_admission(admission_params_hash)
	  	@admission.admission_session = false

	  	@batch_name = Batch.find(@admission.batch_id).name.split("-").first if params[:batch].present?

	    respond_to do |format|
	    	if @admission.valid? == true
	        session[:admission] = @admission
	    		format.json { render :json => { status: :ok, redirect_url: new_admissions_path(@batch_name) }, status: :created }
	  		else
					format.json { render :json => { status: :error, errors: @admission.errors.full_messages.map { |msg| content_tag(:li, msg) }.join }, status: :created }
	  		end
	    end
	  end

		def new
			@new_admission = Student.enroll_new(session[:admission])
		end

		def create
			@new_admission = Student.enroll_new(admissions_params)
			@new_admission.admission_session = true
			respond_to do |format|
				if @new_admission.save
					format.html { redirect_to students_path, notice: "#{@new_admission.full_name} has been enrolled successfully." }
					format.json { render :json => @new_admission }
				else
					format.html { render :new }
					format.json { render :json => @new_admission.errors.full_messages }
					flash[:alert] = "Please Review the Errors Below"
				end
			end
		end

		def cancel_admission
			session[:admission] = nil

			if cookies[:students_index].present?
				redirect_to students_path
			else
				redirect_to authenticated_root_path
				cookies[:students_index] = nil
			end

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

		def admissions_params
			devise_parameter_sanitizer.sanitize(:student)
		end

		def get_new_admission_sections
			@admission_sections = Batch.find(session[:admission]["batch_id"]).sections
		end
	end
end