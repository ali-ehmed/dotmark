module Admins
	class	DashboardController < ApplicationController
		# before_action :require_account!
	
		def index
		end

		def admin_account
			if request.headers['X-Requested-With'] == "XMLHttpRequest"
		    render :layout => false
		  end
		end

		def admin_rights
			if request.headers['X-Requested-With'] == "XMLHttpRequest"
		    render :layout => false
		  end
		end

		def week_days_and_timings
			if request.headers['X-Requested-With'] == "XMLHttpRequest"
		    render :layout => false
		  end
		end
	end
end