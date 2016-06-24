class CreateClassrooms < ActiveRecord::Migration
  def change
    create_table :classrooms do |t|
      t.string :name
      t.string :color
      t.string :strength
      t.string :type_of_room
      t.timestamps null: false
    end
  end
end
