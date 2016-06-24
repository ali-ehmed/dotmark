class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.string :name
      t.string :color
      t.integer :batch_id

      t.timestamps null: false
    end
  end
end
