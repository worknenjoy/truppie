class AddPictureToTour < ActiveRecord::Migration
  def self.up
    add_attachment :tours, :picture
  end

  def self.down
    remove_attachment :tours, :picture
  end
end
