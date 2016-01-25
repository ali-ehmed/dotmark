class Administrations::TimeTableController < ApplicationController
  prepend_before_action :time_table_slots, only: [:show]
  add_breadcrumb "Time Table"

  def index
    @batches = Batch.current_batches
    @sections = @batches.first["sections"]
  end

  def show
    @reservations = TimeTable.generate(params)
    respond_to do |format|
      unless @reservations.blank?
        format.js {}
      else
        format.json { render json: { status: :empty, alert: TimeTable::NULL_RESERVATIONS } }
      end
    end
  end
  
  private

  def time_table_slots
    @week_days = TimeSlot.week_days
    @non_fridays = TimeSlot.non_fridays
    @fridays = TimeSlot.fridays
  end
end
