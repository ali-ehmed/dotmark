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
	validates_uniqueness_of :name
	def which_semester
		name.to_i
	end

	def semester_name
		name.split(" ").first
	end

	class << self
		# Get Semester by Name: -> "Semester.first_semester" etc
		@@semesters ||= ["first, 1", "second, 2", "third, 3", "fourth, 4", "fifth, 5", "sixth, 6", "seventh, 7", "eigth, 8"]
		@@semesters.each do |action|
			name = action.split(", ")
			define_method("#{name.first}_semester") do
				find_by_name("#{name.last.to_i.ordinalize} Semester")
	  	end
		end

		def current_semesters
			semesters = self.all
			current_semesters = Array.new
			if ("July".to_date.month.."December".to_date.month).include?(Date.today.month)
				self.all.each do |semester|
					current_semesters.push({ id: semester.id, name: semester.name }) if semester.which_semester.even?
				end
			else
				self.all.each do |semester|
					current_semesters.push({ id: semester.id, name: semester.name }) if semester.which_semester.odd?
				end
			end

			current_semesters
		end
	end
end
