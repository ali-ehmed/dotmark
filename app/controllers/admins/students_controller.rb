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
			@students, @batch = Student.search(params)
			respond_with :js
		end
	end
end