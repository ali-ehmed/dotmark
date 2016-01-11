class AddAttachmentAvatarToResourceAvatars < ActiveRecord::Migration
  def self.up
    change_table :resource_avatars do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :resource_avatars, :image
  end
end
