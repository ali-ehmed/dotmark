class CreateResourceAvatars < ActiveRecord::Migration
  def change
    create_table :resource_avatars do |t|
      t.integer :resource_id
      t.string :resource_type

      t.timestamps null: false
    end
  end
end
