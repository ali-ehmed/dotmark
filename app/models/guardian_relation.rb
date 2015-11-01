# == Schema Information
#
# Table name: guardian_relations
#
#  id         :integer          not null, primary key
#  parent_id  :integer
#  student_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class GuardianRelation < ActiveRecord::Base
	belongs_to :student
	belongs_to :parent
end
