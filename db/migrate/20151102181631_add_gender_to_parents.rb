class AddGenderToParents < ActiveRecord::Migration
  def change
    add_column :parents, :gender, :string
  end
end
