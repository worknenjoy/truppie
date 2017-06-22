class CreatePaymentTypes < ActiveRecord::Migration
  def change
    create_table :payment_types do |t|
      t.references :marketplace, index: true, foreign_key: true
      t.string :type_name
      t.string :email
      t.string :token
      t.string :appId
      t.string :auth
      t.string :key

      t.timestamps null: false
    end
  end
end
