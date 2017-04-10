class AddDestinationToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :destination, :string
  end
end
