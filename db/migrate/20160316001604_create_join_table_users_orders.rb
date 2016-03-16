class CreateJoinTableUsersOrders < ActiveRecord::Migration
  def change
    create_join_table :users, :orders do |t|
      # t.index [:user_id, :order_id]
      # t.index [:order_id, :user_id]
    end
  end
end
