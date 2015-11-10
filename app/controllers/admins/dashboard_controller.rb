module Admins
	class	DashboardController < ApplicationController
		before_action :require_account!
	
		def dashboard
		end
	end
end