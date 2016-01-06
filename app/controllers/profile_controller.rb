class ProfileController < ApplicationController
	before_action :set_resource

	def profile
	end

	# Account
	def account_update
		respond_to do |format|
			if @resource.update_with_password(resource_account_params)
				sign_in @resource, :bypass => true
				format.html { redirect_to authenticated_root(@account["subdomain"]), notice: "Account successfully updated." }
			else
				@profile_error = true
				params[:tab] = "account"
				format.html { render action: :index }
				format.json { render :json => @resource.errors.full_messages }
			end
		end
	end

	# Settings
	def update
		@resource.password_validity = true
		@resource.email_validity = true
		respond_to do |format|
			if @resource.update_attributes(resource_params)
				sign_in @resource, :bypass => true
				format.html { redirect_to authenticated_root(@account["subdomain"]), notice: "Profile successfully updated." }
			else
				@account_error = true
				params[:tab] = "profile"
				format.html { render action: :index }
				format.json { render :json => @resource.errors.full_messages }
			end
		end
	end

	private

	def set_resource
		@resource = current_resource
		unless current_resource.username == params[:username]
			redirect_to authenticated_root(@account["subdomain"]), flash: { alert: "This area is restricted" }
		end

		@resource
	end

	def resource_account_params
		params.require(@account["resource_type"].downcase.to_sym).permit(:password, :password_confirmation, :current_password)
	end

	def resource_params
		update_account_parameters_sanitizer(:student)
	end
end