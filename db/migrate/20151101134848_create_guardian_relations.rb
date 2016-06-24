class CreateGuardianRelations < ActiveRecord::Migration
  def change
    create_table :guardian_relations do |t|
      t.integer :parent_id
      t.integer :student_id

      t.timestamps null: false
    end
  end
end
