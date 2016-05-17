class AddPictureToOrganizer < ActiveRecord::Migration
  def self.up
    add_attachment :organizers, :picture
  end

  def self.down
    remove_attachment :organizers, :picture
  end
end
