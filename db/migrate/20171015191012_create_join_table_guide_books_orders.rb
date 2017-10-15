class CreateJoinTableGuideBooksOrders < ActiveRecord::Migration
  def change
    create_join_table :guidebooks, :orders do |t|
      t.index [:guidebook_id, :order_id]
      t.index [:order_id, :guidebook_id]
    end
  end
end
