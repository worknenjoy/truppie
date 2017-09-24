class AddPlaceToWhere < ActiveRecord::Migration
  def change
    add_column :wheres, :place_id, :string
    add_column :wheres, :postal_code, :string
    add_column :wheres, :address, :string
    add_column :wheres, :google_id, :string
    add_column :wheres, :url, :string
  end
end
