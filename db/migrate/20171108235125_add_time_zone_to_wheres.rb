class AddTimeZoneToWheres < ActiveRecord::Migration
  def change
    add_column :wheres, :time_zone, :string
    add_index :wheres, :time_zone
  end
end
