class CreateJoinTableToursOrders < ActiveRecord::Migration
  def change
    create_join_table :tours, :orders do |t|
      t.index [:tour_id, :order_id]
      t.index [:order_id, :tour_id]
    end
  end
end
