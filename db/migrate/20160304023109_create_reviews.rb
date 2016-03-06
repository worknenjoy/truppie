class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.references :user, index: true, null: false
      t.references :tour, index: true, null: false
      t.integer :rating
      t.string :content

      t.timestamps null: false
    end
  end
end
