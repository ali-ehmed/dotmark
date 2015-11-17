class AddIsActiveToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :is_active, :boolean, default: false
  end
end
