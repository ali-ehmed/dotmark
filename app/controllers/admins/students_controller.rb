module Admins
	class StudentsController < ApplicationController
		respond_to :js, :html
		def index
			cookies[:students_index] = {
			  value: '_set_student_index',
			  expires: Time.now + 1.minute,
			  domain: request.domain
			}

			@sections = Batch.first.sections
			@batches = Batch.all

			respond_with :js, :html
		end

		def search
			@sections = Section.all
			@batches = Batch.all
			if params[:batch_id_param]
				@batch = Batch.find(params[:batch_id_param])

				if params[:student_name].present?
					@students = @batch.students.where("first_name || ' ' || last_name LIKE ?", "%#{params[:student_name]}%") 
				elsif params[:student_name].present? and params[:roll_no].present?
					@students = @batch.students.where("first_name || ' ' || last_name LIKE ? and roll_number = ?", "%#{params[:student_name]}%", params[:roll_no]) 
				elsif params[:student_name].present? and params[:roll_no].present? and params[:student_section].present?
					@students = @batch.students.where("first_name || ' ' || last_name LIKE ? and roll_number = ? and section_id = ?", "%#{params[:student_name]}%", params[:roll_no], params[:student_section])
				elsif params[:roll_no].present?
					@students = @batch.students.where("roll_number = ?", params[:roll_no])
				elsif params[:student_section].present?
					@students = @batch.students.where("section_id = ?", params[:student_section])
				end
				@students ||= @batch.students
			end
			
			respond_with :js
		end
	end
end