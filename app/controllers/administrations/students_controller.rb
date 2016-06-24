module Administrations
	class StudentsController < ApplicationController
		respond_to :js, :html
		add_breadcrumb "Students"
		
		def index
			@sections = Section.where(batch_id: Batch.current_batches.first["id"])
			@batches = Batch.current_batches

			respond_with :js, :html
		end


		def search
			@students, @batch = Search.students_search(params)
			respond_with :js
		end
	end
end