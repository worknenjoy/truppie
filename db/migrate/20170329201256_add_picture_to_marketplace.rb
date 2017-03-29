class AddPictureToMarketplace < ActiveRecord::Migration
  def change
     add_attachment :marketplaces, :document, :picture
  end
end
