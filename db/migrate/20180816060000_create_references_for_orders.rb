class CreateReferencesForOrders < ActiveRecord::Migration
  def change
    add_reference :orders, :service, index: true
    add_foreign_key :orders, :services    
  end
end