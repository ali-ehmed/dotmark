module Institutes
	class BatchesController < ApplicationController
		def index
			@batches = Batch.all
		end

		def create
			batch = Batch.new(:name => params[:name], start_date: params[:start_date], end_date: params[:start_date])
	  	@batches = Batch.all
	  	if batch.save
	  		respond_to do |format|
	  			format.js
				end
			else
				render json: { status: :error, errors: "#{batch.errors.full_messages.map { |msg| content_tag(:li, msg) }.join}" }, status: :created
			end
		end
	end
end