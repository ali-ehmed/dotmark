module TimeTableSlots
	def slots_data
		@week_days = TimeSlot.week_days
	  @non_fridays = TimeSlot.non_fridays
	  @fridays = TimeSlot.fridays
	end
	
	module_function :slots_data
end