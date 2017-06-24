class AddSourceToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :source, :string
  end
end
