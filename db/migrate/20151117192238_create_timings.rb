class CreateTimings < ActiveRecord::Migration
  def change
    create_table :timings do |t|
      t.time :start_time
      t.time :end_time
      t.string :week_day_type

      t.timestamps null: false
    end
  end
end
