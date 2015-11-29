# == Schema Information
#
# Table name: semesters
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  start_date :date
#  end        :date
#  status     :integer
#

class Semester < ActiveRecord::Base
	has_many :courses

	class << self
		# Get Semester by Name: -> "Semester.first_semester" etc
		["first, 1", "second, 2", "third, 3", "fourth, 4", "fifth, 5", "sixth, 6", "seventh, 7", "eight, 8"].each do |action|
			name = action.split(", ")
			define_method("#{name.first}_semester") do
				find_by_name("#{name.last.to_i.ordinalize} Semester")
	  	end
		end
	end
end
