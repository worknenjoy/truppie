class CreateTours < ActiveRecord::Migration
  def change
    create_table :tours do |t|
      t.string :title
      t.string :description
      t.number :rating
      t.number :value
      t.string :currency
      t.references :organizer, index: true, foreign_key: true
      t.datetime :start
      t.datetime :end
      t.string :picture
      t.number :availability
      t.number :minimum
      t.number :maximum
      t.references :pictures, index: true, foreign_key: true
      t.number :difficulty
      t.references :where, index: true, foreign_key: true
      t.string :address
      t.references :user, index: true, foreign_key: true
      t.references :included, index: true, foreign_key: true
      t.references :nonincluded, index: true, foreign_key: true
      t.references :category, index: true, foreign_key: true
      t.references :tags, index: true, foreign_key: true
      t.references :attractions, index: true, foreign_key: true
      t.string :privacy
      t.string :meetingpoint
      t.references :confirmed, index: true, foreign_key: true
      t.references :languages, index: true, foreign_key: true
      t.references :reviews, index: true, foreign_key: true
      t.string :verified
      t.string :status

      t.timestamps null: false
    end
  end
end
