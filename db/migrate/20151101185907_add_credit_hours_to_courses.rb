class AddCreditHoursToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :credit_hours, :string
    add_column :courses, :lab, :boolean
  end
end
