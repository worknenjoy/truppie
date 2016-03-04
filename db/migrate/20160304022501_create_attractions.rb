class CreateAttractions < ActiveRecord::Migration
  def change
    create_table :attractions do |t|
      t.string :name
      t.string :lat
      t.string :long
      t.string :city
      t.string :state
      t.string :country
      t.references :category, index: true, foreign_key: true
      t.references :tags, index: true, foreign_key: true
      t.references :language, index: true, foreign_key: true
      t.string :currency
      t.references :quotes, index: true, foreign_key: true
      t.string :bestseason

      t.timestamps null: false
    end
  end
end
