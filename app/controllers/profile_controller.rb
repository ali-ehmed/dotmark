class ProfileController < ApplicationController
	before_action :set_resource

	def profile
	end

	def account_update
		respond_to do |format|
			if @resource.update_with_password(resource_account_params)
				sign_in @resource, :bypass => true
				format.html { redirect_to authenticated_root(@account.subdomain), notice: "Account successfully updated." }
			else
				@profile_error = true
				format.html { render :index }
				format.json { render :json => @resource.errors.full_messages }
			end
		end
	end

	def update
		@resource.check_valididty = true
		respond_to do |format|
			if @resource.update_attributes(resource_params)
				sign_in @resource, :bypass => true
				format.html { redirect_to authenticated_root(@account.subdomain), notice: "Profile successfully updated." }
			else
				@account_error = true
				format.html { render :index }
				format.json { render :json => @resource.errors.full_messages }
			end
		end
	end

	def expired_confirmations
		@confirmation_resource = @resource.class.new
	end

	private

	def set_resource
		@resource = @account.resource
	end

	def resource_account_params
		params.require(@account.resource_type.downcase.to_sym).permit(:password, :password_confirmation, :current_password)
	end

	def resource_params
		update_account_parameters_sanitizer(:student)
	end
end