class AddDestinationToGuideBook < ActiveRecord::Migration
  def change
    add_reference :guidebooks, :destination, index: true, foreign_key: true
  end
end
