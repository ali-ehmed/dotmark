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
	validates :start_date, presence: { message: "date can't be blank" }
	validates :end_date, presence: { message: "date can't be blank" }
	validate :set_session_date


	def set_session_date
		unless start_date.blank? || end_date.blank?
			errors.add :base, "End date must be greater than Start date" if self.start_date > self.end_date
		end
	end
end
