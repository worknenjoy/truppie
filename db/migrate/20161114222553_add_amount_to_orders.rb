class AddAmountToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :amount, :integer, default: 1
    add_column :orders, :final_price, :integer
  end
end
