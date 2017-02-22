class AddFeesToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :liquid, :integer
    add_column :orders, :fee, :integer
  end
end
