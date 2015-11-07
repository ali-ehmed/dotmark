class AdminsController < ApplicationController
	before_action :require_account!
	
	def dashboard
	end
end
