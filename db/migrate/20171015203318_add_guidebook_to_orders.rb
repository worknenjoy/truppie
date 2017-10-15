class AddGuidebookToOrders < ActiveRecord::Migration
  def change
    add_reference :orders, :guidebook, index: true, foreign_key: true
  end
end
