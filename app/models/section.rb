# == Schema Information
#
# Table name: sections
#
#  id         :integer          not null, primary key
#  name       :string
#  color      :string
#  batch_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Section < ActiveRecord::Base
	belongs_to :batch
end
