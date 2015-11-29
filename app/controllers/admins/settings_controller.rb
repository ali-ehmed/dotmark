module Admins
	class	SettingsController < ApplicationController
		before_action :authenticate_admin!
	
		def index
		end

		def admin_account
			@admin = current_admin
		end

		def week_days_and_timings
		end

		def update
			@admin = current_admin
			if @admin.update_attributes(admin_params)
				redirect_to admin_account_settings_path, notice: "Account Updated"
			else
				render :admin_account
			end
		end

		def method_name
			
		end

		private

		def admin_params
			params.require(:admin).permit(:email, :username, :password, :password_confirmation)
		end
	end
end