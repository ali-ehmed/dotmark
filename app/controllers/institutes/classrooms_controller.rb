module Institutes
	class ClassroomsController < BaseController
		add_breadcrumb "Classrooms"

		def index
			@classrooms = Classroom.all
			@classroom = Classroom.new

			respond_to do |format|
	  		format.html
	  		format.json { render json: { data: @classrooms } }
			end
		end

		def create
			classroom = Classroom.new(classroom_params)
	  	@classrooms = Classroom.all
	  	if classroom.save
	  		respond_to do |format|
	  			format.js
				end
			else
				render json: { status: :error, errors: "#{classroom.errors.full_messages.map { |msg| content_tag(:li, msg) }.join}" }, status: :created
			end
		end

		def edit
			@classroom = Classroom.find(params[:id])
		end

		def update
			@classroom = Classroom.find(params[:id])
	  	if @classroom.update_attributes(classroom_params)
	  		respond_to do |format|
	  			format.html { redirect_to institutes_classrooms_path, notice: "Classroom Updated" }
				end
			else
				format.html { render :edit }
				flash[:error] = @classroom.full_messages.to_sentence
			end
		end

		def destroy
			@classroom = Classroom.find params[:id]
			@classroom.destroy
			redirect_to institutes_classrooms_path, notice: "Classroom Removed Successfully"
		end

		def classroom_params
			params.require(:classroom).permit(:name, :color, :strength, :type_of_room)
		end
	end
end