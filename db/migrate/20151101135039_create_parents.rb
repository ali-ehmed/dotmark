class CreateParents < ActiveRecord::Migration
  def change
    create_table :parents do |t|
      t.string :name
      t.string :phone
      t.text :home_address
      t.string :occupation
      t.string :monthly_income

      t.timestamps null: false
    end
  end
end
