class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.references :user, index: true, foreign_key: true
      t.number :rating
      t.string :content

      t.timestamps null: false
    end
  end
end
