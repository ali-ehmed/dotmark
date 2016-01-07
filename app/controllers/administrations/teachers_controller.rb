module Administrations
	class	TeachersController < ApplicationController
		add_breadcrumb "Teachers"
		
		def index
			@teachers = Teacher.present
		end

		def search
			@teachers = Search.teachers_search(params)
			render :index
		end

		def update
			@teacher = Teacher.find(params[:id])
			respond_to do |format|
				if @teacher.update_attributes(teacher_params)
					format.json { respond_with_bip(@teacher) }
				else
					format.json { respond_with_bip(@teacher) }
				end
			end
		end

		def teacher_params
			params.require(:teacher).permit(:full_name, :date_of_birth, :joining_date, :phone)
		end
	end
end