class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :body
      t.string :resource_type
      t.integer :resource_id
      t.datetime :sent_at

      t.timestamps null: false
    end
  end
end
