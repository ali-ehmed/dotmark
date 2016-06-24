# == Schema Information
#
# Table name: allocated_sections
#
#  id                   :integer          not null, primary key
#  course_allocation_id :integer
#  section_id           :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

require 'test_helper'

class AllocatedSectionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
