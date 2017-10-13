class CreateGuidebooks < ActiveRecord::Migration
  def change
    create_table :guidebooks do |t|
      t.string :title
      t.string :description
      t.integer :rating
      t.integer :value
      t.string :currency
      t.references :organizer, index: true, foreign_key: true, null: false
      t.references :user, index: true, foreign_key: true, null: false
      t.string :privacy
      t.string :verified
      t.string :status
      t.attachment :picture
      t.attachment :file
      t.references :category, index: true, foreign_key: true

      t.string :included, array: true, default: []
      t.string :nonincluded, array: true, default: []

      t.timestamps null: false
    end
  end
end
