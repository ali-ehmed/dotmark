class AddTempPasswordToStudents < ActiveRecord::Migration
  def change
  	add_column :students, :temp_password, :text
  end
end
