module Administrations
	class	SettingsController < ApplicationController
		before_action :authenticate_admin!
		
		def admin_account
			@admin = current_admin
		end

		def week_days_and_timings
			@week_days = TimeSlot.week_days
			@normal_timings = TimeSlot.non_fridays
			@friday_timings = TimeSlot.fridays
		end

		def current_batches
			@current_batches = Batch.current_batches
		end

		def update
			@admin = current_admin
			if @admin.update_attributes(admin_params)
				sign_in :admin, @admin, :bypass => true
				redirect_to admin_account_settings_path, notice: "Account Updated"
			else
				render :admin_account
			end
		end

		private

		def admin_params
			params.require(:admin).permit(:email, :username, :password, :password_confirmation)
		end
	end
end