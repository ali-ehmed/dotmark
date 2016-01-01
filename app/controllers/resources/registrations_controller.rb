module Resources
	class RegistrationsController < Devise::RegistrationsController
		def new
			build_resource({})
			if resource.class == Student
				@shared = "administrations/admissions"
				self.resource = Student.enroll_new(session[:admission])
			end
			respond_with self.resource
		end

		def create
			build_resource({})
			if self.resource.class == Student
				@shared = "administrations/admissions"
				self.resource = Student.enroll_new(admissions_params)
				self.resource.email_validity = true
			else
				build_resource(sign_up_params)
			end
			# resource.skip_confirmation!
	    resource.save
	    yield resource if block_given?
	    if resource.persisted?
	      flash[:notice] = "#{resource.full_name} has been registered successfully as a #{resource.class.to_s}"
        respond_with resource, location: after_sign_up_path_for(resource)
	    else
	      respond_with resource
	    end
		end

		private

		def after_sign_up_path_for(resource)
			expire_session_data_after_sign_in!
			if resource.class == Student
		    students_path
			else
		    teachers_path
	    end
	  end

	  def admissions_params
			devise_parameter_sanitizer.sanitize(:student)
		end

	  # It is used if not to sign in resource after sign up
	  # def sign_up(resource_name, resource)
	  #   true
	  # end
	end
end