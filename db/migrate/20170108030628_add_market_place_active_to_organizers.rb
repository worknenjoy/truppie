class AddMarketPlaceActiveToOrganizers < ActiveRecord::Migration
  def change
    add_column :organizers, :market_place_active, :boolean, default: false
  end
end
