module Admins
	class StudentsController < ApplicationController
		respond_to :js, :html
		
		def index
			@sections = Batch.first.sections
			@batches = Batch.all.order("name desc").limit(5).reverse

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