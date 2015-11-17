class CreateTeachers < ActiveRecord::Migration
  def change
    create_table :teachers do |t|
      t.string :first_name
      t.string :last_name
      t.string :gender
      t.date :date_of_birth
      t.date :joining_date
      t.text :qualification
      t.string :past_experience
      t.string :phone
      t.string :skills
      t.boolean :present

      t.timestamps null: false
    end
  end
end
