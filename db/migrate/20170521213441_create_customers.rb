class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :token
      t.string :email
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
