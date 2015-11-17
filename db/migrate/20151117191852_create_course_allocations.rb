class CreateCourseAllocations < ActiveRecord::Migration
  def change
    create_table :course_allocations do |t|
      t.integer :course_id
      t.integer :teacher_id
      t.integer :batch_id
      t.string :timings
      t.integer :class_timing_id
      t.integer :week_day_id

      t.timestamps null: false
    end
  end
end
