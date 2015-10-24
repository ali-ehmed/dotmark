module Institutes
	class ClassroomsController < ApplicationController
		def index
			@classrooms = Classroom.all
		end

		def create
			classroom = Classroom.new(:name => params[:name], color: params[:classroom_color], strength: params[:classroom_strength])
	  	@classrooms = Classroom.all
	  	if classroom.save
	  		respond_to do |format|
	  			format.js
				end
			else
				render json: { status: :error, errors: "#{classroom.errors.full_messages.map { |msg| content_tag(:li, msg) }.join}" }, status: :created
			end
		end

		def destroy
			@classroom = Classroom.find params[:id]
			@classroom.destroy
			redirect_to institutes_classrooms_path, notice: "Classroom Removed Successfully"
		end
	end
end