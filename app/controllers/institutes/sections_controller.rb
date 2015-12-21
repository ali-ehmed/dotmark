module Institutes
	class SectionsController < BaseController
		add_breadcrumb "Sections"
		def index
			@batches = Batch.all
			@sections = []
		end

		def update
			@section = Section.find params[:id]

		  respond_to do |format|
		  	if params[:color].present?
			    @section.color = params[:color]
			    @section.save!
			    format.json { render json: { status: :ok, color: @section.color }, status: :created }
			  else
			  	format.json { render json: { status: :error }, status: :created }
			  end
		  end
		end
	end
end