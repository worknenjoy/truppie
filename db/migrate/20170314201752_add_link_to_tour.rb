class AddLinkToTour < ActiveRecord::Migration
  def change
    add_column :tours, :link, :string
  end
end
