class AddAndRemoveFieldsToCourseAllocations < ActiveRecord::Migration
  def self.up
  	remove_column :course_allocations, :class_timing_id
  	remove_column :course_allocations, :week_day_id
  	add_column :course_allocations, :time_slot_id, :integer
  	add_column :course_allocations, :classroom_id, :integer
  end

  def self.down
  	add_column :course_allocations, :class_timing_id, :integer
  	add_column :course_allocations, :week_day_id, :integer
  	remove_column :course_allocations, :time_slot_id
  	remove_column :course_allocations, :classroom_id
  end
end
