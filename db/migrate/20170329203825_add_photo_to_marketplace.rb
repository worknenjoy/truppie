class AddPhotoToMarketplace < ActiveRecord::Migration
  def change
    add_attachment :marketplaces, :photo
  end
end
