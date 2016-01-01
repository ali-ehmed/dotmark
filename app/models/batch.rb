# == Schema Information
#
# Table name: batches
#
#  id         :integer          not null, primary key
#  name       :string
#  start_date :date
#  end_date   :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Batch < ActiveRecord::Base
	validates :name, presence: { message: "can't be blank" }
	validates :start_date, presence: { message: "can't be blank" }
	validates :end_date, presence: { message: "can't be blank" }
	validate :set_session_date

	has_many :sections
	has_many :courses
	has_many :students

	# Allocated courses in a batch
	has_many :course_allocations
	validates_uniqueness_of :name

	accepts_nested_attributes_for :sections
	extend ApplicationHelper

	scope :allocations, -> (batch_id) { find(batch_id).course_allocations }

	def self.current_batches
		if Batch.batches_running_currently.count > 1
			Batch.where("id in (?)", self.batches_running_currently.map{|m| m[:id]}) 
		else

			Batch.build_current_batch
			Batch.where("id in (?)", self.batches_running_currently.map{|m| m[:id]}) 
		end
	end

	def set_session_date
		unless start_date.blank? || end_date.blank?
			errors.add :base, "End date must be greater than Start date" if self.start_date > self.end_date
		end
	end

	def batch_name
		name.split("-").first
	end

	def self.batches_running_currently
		current_batch_year = Batch.where("name like ?", "%#{Date.today.year.to_s}%")
		current_semester = Semester.current_semesters.last[:name].to_i

		@batches = Array.new

		unless current_batch_year.map(&:batch_name).include? Date.today.year.to_s
			@batches << "Please create '#{Date.today.year}' batch."
			return @batches
		end
		
		attributes = {}
		for current_year in current_batch_year
			if current_year.batch_name.include?(Date.today.year.to_s)
				current_batch = current_year.batch_name.to_i
				prev_batches_year = current_year.batch_name.to_i - 3

				range = current_batch..prev_batches_year

				(range.first).downto(range.last).each do |prev_batch_year|
					prev_batches = Batch.where("name like ?", "%#{(prev_batch_year).to_s}%")

					for prev_batch in prev_batches
						if prev_batch.batch_name.include?(prev_batch_year.to_s)
							semester = Semester.send("#{ordinalize_word(current_semester).downcase}_semester")

							attributes = {
								id: prev_batch.id,
								name: prev_batch.batch_name,
								start_date: prev_batch.start_date,
								end_date: prev_batch.end_date,
								semester: semester.name
							}
							@batches.push(attributes)
							current_semester -= 2 #use to get current semster from semester array
						end
					end
				end
			end
		end

		logger.debug "#{@batches}"
		return @batches
	end

	def self.build_current_batch
		first_year = Date.today.year
		last_year = Date.today.year + 3
		new_batch = "#{first_year}-#{last_year}"

		find_or_create_by!(name: new_batch) do |batch|
			batch.start_date = "#{first_year.to_s}-01-01"
			batch.end_date = "#{last_year.to_s}-12-25"
		end
	end
end
