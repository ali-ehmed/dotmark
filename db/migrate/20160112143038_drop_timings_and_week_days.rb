class DropTimingsAndWeekDays < ActiveRecord::Migration
  def self.up
  	drop_table :week_days
  	drop_table :timings
  end

  def self.down
  	create_table :timings do |t|
      t.time :start_time
      t.time :end_time
      t.string :week_day_type

      t.timestamps null: false
    end

    create_table :week_days do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
