# == Schema Information
#
# Table name: week_days
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class WeekDay < ActiveRecord::Base
end
