class AddReservedToTours < ActiveRecord::Migration
  def change
    add_column :tours, :reserved, :integer, default: 0
  end
end
