# == Schema Information
#
# Table name: teachers
#
#  id              :integer          not null, primary key
#  first_name      :string
#  last_name       :string
#  gender          :string
#  date_of_birth   :date
#  joining_date    :date
#  qualification   :text
#  past_experience :string
#  phone           :string
#  skills          :string
#  present         :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'test_helper'

class TeacherTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
