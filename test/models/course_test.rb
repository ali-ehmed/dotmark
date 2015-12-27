# == Schema Information
#
# Table name: courses
#
#  id           :integer          not null, primary key
#  name         :string
#  code         :string
#  color        :string
#  semester_id  :integer
#  batch_id     :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  credit_hours :string
#  lab          :boolean
#  course_type  :string
#

require 'test_helper'

class CourseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
