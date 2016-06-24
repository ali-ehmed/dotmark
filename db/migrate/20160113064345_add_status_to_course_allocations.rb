class AddStatusToCourseAllocations < ActiveRecord::Migration
  def change
    add_column :course_allocations, :status, :integer, default: 0
  end
end
