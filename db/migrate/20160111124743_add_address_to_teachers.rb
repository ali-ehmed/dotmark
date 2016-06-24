class AddAddressToTeachers < ActiveRecord::Migration
  def change
    add_column :teachers, :address, :text
  end
end
