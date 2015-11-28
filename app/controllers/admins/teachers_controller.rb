module Admins
	class	TeachersController < ApplicationController
		def index
			@teachers = Teacher.present
		end

		def search
			@teachers = Teacher.search(params)
			render :index
		end
	end
end