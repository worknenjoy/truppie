class AddRemovedToTours < ActiveRecord::Migration
  def change
    add_column :tours, :removed, :boolean
  end
end
