class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :first_name
      t.string :last_name
      t.string :roll_number
      t.string :phone
      t.text :address
      t.date :date_of_birth
      t.date :joining_date
      t.boolean :passed_out
      t.date :passed_out_date
      t.integer :section_id
      t.integer :batch_id
      t.string :semester_id

      t.timestamps null: false
    end
  end
end
