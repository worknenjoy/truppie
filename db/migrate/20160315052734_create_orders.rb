class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :own_id
      t.references :tour, index: true
      t.references :user, index: true
      t.string :status
      t.integer :price
      t.integer :discount
      
      t.timestamps null: false
    end
    
    add_foreign_key :orders, :tours
    
  end
end
