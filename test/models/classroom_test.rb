# == Schema Information
#
# Table name: classrooms
#
#  id           :integer          not null, primary key
#  name         :string
#  color        :string
#  strength     :string
#  type_of_room :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class ClassroomTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
