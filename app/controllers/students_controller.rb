class StudentsController < ApplicationController\
	
	def index
		cookies[:students_index] = Time.now + 1.minute
	end

	def dashboard	
	end
end