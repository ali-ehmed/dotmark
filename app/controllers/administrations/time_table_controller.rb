class Administrations::TimeTableController < ApplicationController
  include TimeTableSlots

  prepend_before_action :slots_data, only: [:show]
  add_breadcrumb "Time Table"

  def index
    @batches = Batch.current_batches
    @sections = @batches.first["sections"]
  end

  def show
    @reservations = TimeTable.generate(params)
    @params = params
    respond_to do |format|
      unless @reservations.blank?
        format.js {}
        format.html { render partial: 'administrations/time_table/generated_time_table' }
      else
        format.json { render json: { status: :empty, alert: TimeTable::NULL_RESERVATIONS } }
      end
    end
  end
end
