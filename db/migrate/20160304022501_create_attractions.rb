class CreateAttractions < ActiveRecord::Migration
  def change
    create_table :attractions do |t|
      t.string :name
      t.text :name
      t.string :lat
      t.string :long
      t.string :city
      t.string :state
      t.string :country
      t.references :language, index: true
      t.string :currency
      t.references :quote, index: true
      t.string :bestseason

      t.timestamps null: false
    end
  end
end
