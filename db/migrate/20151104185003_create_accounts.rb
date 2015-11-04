class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :subdomain
      t.string :resource_type
      t.integer :resource_id

      t.timestamps null: false
    end
  end
end
