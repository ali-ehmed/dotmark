class AddSemesterIdToCourseAllocations < ActiveRecord::Migration
  def change
    add_column :course_allocations, :semester_id, :integer
  end
end
