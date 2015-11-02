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
end
