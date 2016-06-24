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

require 'test_helper'

class GuardianRelationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
