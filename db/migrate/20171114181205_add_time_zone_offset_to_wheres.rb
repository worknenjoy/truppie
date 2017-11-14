class AddTimeZoneOffsetToWheres < ActiveRecord::Migration
  def change
    add_column :wheres, :utc_offset, :integer
  end
end
