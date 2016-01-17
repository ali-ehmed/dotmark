class CreateTimeTables < ActiveRecord::Migration
  def change
    create_table :time_tables do |t|
      t.integer :time_slot_id
      t.integer :classroom_id
      t.integer :course_allocation_id
      t.integer :status

      t.timestamps null: false
    end
  end
end
