# == Schema Information
#
# Table name: course_allocations
#
#  id              :integer          not null, primary key
#  course_id       :integer
#  teacher_id      :integer
#  batch_id        :integer
#  timings         :string
#  class_timing_id :integer
#  week_day_id     :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  section_id      :integer
#

require 'test_helper'

class CourseAllocationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
