class StudentsController < ApplicationController
	before_action :set_index, :only [:index]
	
	def index
	end

	private

	def set_index
		cookies[:students_index] = Time.now + 1.minute
	end
end