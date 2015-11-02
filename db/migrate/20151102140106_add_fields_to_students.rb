class AddFieldsToStudents < ActiveRecord::Migration
  def change
  	add_column :students, :gender, :string
  	add_column :students, :nationality, :string
  end
end
