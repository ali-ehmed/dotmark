class AddTempPasswordToTeachers < ActiveRecord::Migration
  def change
    add_column :teachers, :temp_password, :text
  end
end
