class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.string :code
      t.string :color
      t.integer :batch_id

      t.timestamps null: false
    end
  end
end
