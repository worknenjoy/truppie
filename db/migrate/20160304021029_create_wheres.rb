class CreateWheres < ActiveRecord::Migration
  def change
    create_table :wheres do |t|
      t.string :name
      t.string :lat
      t.string :long
      t.string :city
      t.string :state
      t.string :country

      t.timestamps null: false
    end
  end
end
