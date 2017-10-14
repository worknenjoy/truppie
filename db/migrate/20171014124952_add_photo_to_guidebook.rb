class AddPhotoToGuidebook < ActiveRecord::Migration
  def change
    add_column :guidebooks, :photo, :string
  end
end
