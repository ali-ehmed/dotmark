class AddFieldsToSemester < ActiveRecord::Migration
  def change
  	add_column :semesters, :start_date, :date
    add_column :semesters, :end, :date
    add_column :semesters, :status, :integer
  end
end
