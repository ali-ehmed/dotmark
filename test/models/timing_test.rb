# == Schema Information
#
# Table name: timings
#
#  id            :integer          not null, primary key
#  start_time    :time
#  end_time      :time
#  week_day_type :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class TimingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
