# == Schema Information
#
# Table name: timings
#
#  id            :integer          not null, primary key
#  start_time    :time
#  end_time      :time
#  week_day_type :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Timing < ActiveRecord::Base

	scope :non_fridays, -> { where(week_day_type: "Normal Day") }
	scope :fridays, -> { where(week_day_type: "FriDay") }

	def timings
		"#{start_time} - #{end_time}"
	end
end
