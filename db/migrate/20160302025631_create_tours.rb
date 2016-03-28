class CreateTours < ActiveRecord::Migration
  def change
    create_table :tours do |t|
      t.string :title
      t.string :description
      t.integer :rating
      t.integer :value
      t.string :currency
      t.references :organizer, index: true, null: false
      t.datetime :start
      t.datetime :end
      t.string :photo
      t.integer :availability
      t.integer :minimum
      t.integer :maximum
      t.integer :difficulty
      t.references :where, index: true, null:false
      t.string :address
      t.references :user, index: true, null:false
      t.text :included, array: true, default: []
      t.text :nonincluded, array: true, default: []
      t.text :take, array: true, default: []
      t.text :goodtoknow, array: true, default: []
      t.references :category, index: true
      t.references :tag, index: true
      t.references :attraction, index: true
      t.string :privacy
      t.string :meetingpoint
      t.references :confirmed, index: true
      t.references :language, index: true
      t.references :review, index: true
      t.string :verified
      t.string :status
      t.timestamps null: false
    end
  end
end
