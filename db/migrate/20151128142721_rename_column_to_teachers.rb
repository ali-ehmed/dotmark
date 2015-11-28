class RenameColumnToTeachers < ActiveRecord::Migration
  def self.up
  	rename_column :teachers, :present, :is_present
  end

  def self.down
  	rename_column :teachers, :is_present, :present
  end
end
