module Institutes
	class SectionsController < ApplicationController
		def index
			@batches = Batch.all
			@sections = []
		end

		def get_sections
			if params[:batch_id].blank?
				@sections = []
			else
				@batch = Batch.find(params[:batch_id])
				@sections = @batch.sections
			end
			respond_to do |format|
				format.js
			end
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