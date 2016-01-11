class ProfilesController < ApplicationController
	before_action :set_resource
	before_action :upload_image, only: [:index, :edit, :update]

	def index
		render :profile
	end

	def edit
		respond_to do |format|
			format.html { render :template => template }
			format.js {}
		end
	end

	# Account
	def security
		respond_to do |format|
			if @resource.update_with_password(resource_account_params)
				sign_in @resource, :bypass => true
				format.html { redirect_to profiles_path(params[:username]), notice: "Account successfully updated." }
			else
				if params[:tab] == "account"
					@security_error = Account::CurrentPassword
				else
					flash.now[:warning] = content_tag(:li, @resource.errors.full_messages.to_sentence)
				end
				format.html { render template }
				format.json { render :json => @resource.errors.full_messages }
			end
		end
	end

	# profile
	def update
		@resource.password_validity = true
		@resource.email_validity = true
		respond_to do |format|
			if @resource.update_attributes(resource_params)
				$redis.del("user_avatar")
				sign_in @resource, :bypass => true
				format.html { redirect_to profiles_path(params[:username]), notice: "Profile successfully updated." }
			else
				flash.now[:warning] = content_tag(:li, @resource.errors.full_messages.to_sentence)
				format.html { render template }
				format.json { render :json => @resource.errors.full_messages }
			end
		end
	end

	def upload_image
		@resource.build_avatar if @resource.avatar.blank?
	end

	private

	def set_resource
		@resource = current_resource
		unless current_resource.username == params[:username]
			redirect_to authenticated_root(@account["subdomain"]), flash: { alert: "This area is restricted" }
		end

		@resource
	end

	def template
		@@template = "devise/registrations/edit"
	end

	def resource_account_params
		params.require(@account["resource_type"].downcase.to_sym).permit(:password, :password_confirmation, :current_password)
	end

	def resource_params
		update_account_parameters_sanitizer(@account["resource_type"].downcase.to_sym)
	end
end